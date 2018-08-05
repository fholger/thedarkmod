/*****************************************************************************
                    The Dark Mod GPL Source Code
 
 This file is part of the The Dark Mod Source Code, originally based 
 on the Doom 3 GPL Source Code as published in 2011.
 
 The Dark Mod Source Code is free software: you can redistribute it 
 and/or modify it under the terms of the GNU General Public License as 
 published by the Free Software Foundation, either version 3 of the License, 
 or (at your option) any later version. For details, see LICENSE.TXT.
 
 Project: The Dark Mod (http://www.thedarkmod.com/)
 
******************************************************************************/

#include "precompiled.h"
#include "DynamicResolutionScaler.h"
#include "tr_local.h"

DynamicResolutionScaler resolutionScaler;

idCVar rs_enable( "rs_enable", "0", CVAR_BOOL|CVAR_RENDERER|CVAR_ARCHIVE, "Enable dynamic resolution scaling" );
idCVar rs_targetFps( "rs_targetFps", "60", CVAR_INTEGER|CVAR_RENDERER|CVAR_ARCHIVE, "The target framerate for resolution scaling" );
idCVar rs_dropThreshold( "rs_dropThreshold", "0.95", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "The fraction of the frame time at which to drop resolution" );
idCVar rs_raiseThreshold( "rs_raiseThreshold", "0.75", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "The fraction of the frame time at which to raise resolution" );
idCVar rs_dropFrames( "rs_dropFrames", "3", CVAR_INTEGER|CVAR_RENDERER|CVAR_ARCHIVE, "Number of bad frames before dropping resolution" );
idCVar rs_raiseFrames( "rs_raiseFrames", "10", CVAR_INTEGER|CVAR_RENDERER|CVAR_ARCHIVE, "Number of good frames before raising resolution" );
idCVar rs_factor( "rs_factor", "0.1", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "The factor with which to multiply resolution modifications" );
idCVar rs_minResolution( "rs_minResolution", "0.5", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "The minimum resolution scale" );
idCVar rs_showScale( "rs_showScale", "0", CVAR_BOOL|CVAR_RENDERER|CVAR_ARCHIVE, "Display current resolution scale" );


DynamicResolutionScaler::DynamicResolutionScaler(): timerQueries{}, frameMarker( 0 ), currentScale( 1 ),
                                                    framesAboveRaise( 0 ), framesBelowDrop( 0 ) {}

void DynamicResolutionScaler::Init() {
	if( glConfig.timerQueriesAvailable ) {
		qglGenQueries( NUM_FRAMES, timerQueries );
	}
	DetermineThresholds();
}

void DynamicResolutionScaler::Shutdown() {
	if( glConfig.timerQueriesAvailable ) {
		qglDeleteQueries( NUM_FRAMES, timerQueries );
	}
}

void DynamicResolutionScaler::BeginRecordGpuTime() {
	if( glConfig.timerQueriesAvailable && rs_enable.GetBool() ) {
		qglBeginQuery( GL_TIME_ELAPSED, timerQueries[ frameMarker ] );
	}
}

void DynamicResolutionScaler::EndRecordGpuTime() {
	if( !glConfig.timerQueriesAvailable || !rs_enable.GetBool() ) {
		return;
	}

	qglEndQuery( GL_TIME_ELAPSED );
	// fetch results from a previous frame that is hopefully ready by now
	frameMarker = ( frameMarker + 1 ) % NUM_FRAMES;
	uint64 gpuDrawTimeNanos = 0;
	qglGetQueryObjectui64v( timerQueries[ frameMarker ], GL_QUERY_RESULT, &gpuDrawTimeNanos );
	AdjustTargetResolution( gpuDrawTimeNanos );
}

void DynamicResolutionScaler::DetermineThresholds() {
	if( rs_targetFps.GetInteger() <= 0 ) {
		common->Printf( "Render framerate set to invalid value; resetting to default" );
		rs_targetFps.SetInteger( 60 );
	}

	double targetFrametimeNanos = 1000000000.0 / rs_targetFps.GetInteger();
	dropThresholdNanos = ( uint64 )( targetFrametimeNanos * rs_dropThreshold.GetFloat() );
	raiseThresholdNanos = ( uint64 )( targetFrametimeNanos * rs_raiseThreshold.GetFloat() );
	framesAboveRaise = 0;

	rs_targetFps.ClearModified();
	rs_dropThreshold.ClearModified();
	rs_raiseThreshold.ClearModified();
}

void DynamicResolutionScaler::AdjustTargetResolution( uint64 gpuFrameTimeNanos ) {
	if( rs_targetFps.IsModified() || rs_dropThreshold.IsModified() || rs_raiseThreshold.IsModified() ) {
		DetermineThresholds();
	}

	// all adjustments to the scale are by square root, since the scale factor applies to both width and height
	if( gpuFrameTimeNanos > dropThresholdNanos ) {
		++framesBelowDrop;
		if( framesBelowDrop >= rs_dropFrames.GetInteger() ) {
			float dropPercentage = rs_factor.GetFloat() * currentScale * ( gpuFrameTimeNanos - dropThresholdNanos ) / dropThresholdNanos;
			currentScale = currentScale - sqrtf( dropPercentage );
			framesBelowDrop = 0;
		}
	} else {
		framesBelowDrop = 0;
	}

	if( gpuFrameTimeNanos < raiseThresholdNanos ) {
		++framesAboveRaise;
		if( framesAboveRaise >= rs_raiseFrames.GetInteger() ) {
			float raisePercentage = 0.5 * rs_factor.GetFloat() * currentScale * ( raiseThresholdNanos - gpuFrameTimeNanos ) / raiseThresholdNanos;
			currentScale = currentScale + sqrtf( raisePercentage );
			framesAboveRaise = 0;
		}
	} else {
		framesAboveRaise = 0;
	}

	if( currentScale < rs_minResolution.GetFloat() ) {
		currentScale = rs_minResolution.GetFloat();
	}
	if( currentScale > 1.0f ) {
		currentScale = 1.0f;
	}
}
