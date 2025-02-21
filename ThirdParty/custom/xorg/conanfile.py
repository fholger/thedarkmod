from conan import ConanFile, conan_version
from conan.tools.gnu import PkgConfig
from conan.tools.system import package_manager
from conan.errors import ConanInvalidConfiguration

required_conan_version = ">=1.50.0"


def filter_list(elements, excluded_str):
    excluded_list = str(excluded_str).split(',')
    return [x for x in elements if x not in excluded_list]


class XorgConan(ConanFile):
    name = "xorg"
    package_type = "shared-library"
    url = "https://github.com/conan-io/conan-center-index"
    license = "MIT"
    homepage = "https://www.x.org/wiki/"
    description = "The X.Org project provides an open source implementation of the X Window System."
    settings = "os", "arch", "compiler", "build_type"
    topics = ("x11", "xorg")

    options = {
        "exclude_install": ["ANY"],
        "exclude_lib": ["ANY"],
    }
    default_options = {
        "exclude_install": "",
        "exclude_lib": "",
    }

    def validate(self):
        if self.settings.os not in ["Linux", "FreeBSD"]:
            raise ConanInvalidConfiguration("This recipe supports only Linux and FreeBSD")

    def package_id(self):
        self.info.clear()

    def system_requirements(self):
        apt = package_manager.Apt(self)
        apt.install(filter_list(["libx11-dev", "libx11-xcb-dev", "libfontenc-dev", "libice-dev", "libsm-dev", "libxau-dev", "libxaw7-dev",
                     "libxcomposite-dev", "libxcursor-dev", "libxdamage-dev", "libxdmcp-dev", "libxext-dev", "libxfixes-dev",
                     "libxi-dev", "libxinerama-dev", "libxkbfile-dev", "libxmu-dev", "libxmuu-dev",
                     "libxpm-dev", "libxrandr-dev", "libxrender-dev", "libxres-dev", "libxss-dev", "libxt-dev", "libxtst-dev",
                     "libxv-dev", "libxxf86vm-dev", "libxcb-glx0-dev", "libxcb-render0-dev",
                     "libxcb-render-util0-dev", "libxcb-xkb-dev", "libxcb-icccm4-dev", "libxcb-image0-dev",
                     "libxcb-keysyms1-dev", "libxcb-randr0-dev", "libxcb-shape0-dev", "libxcb-sync-dev", "libxcb-xfixes0-dev",
                     "libxcb-xinerama0-dev", "libxcb-dri3-dev", "uuid-dev", "libxcb-cursor-dev", "libxcb-dri2-0-dev",
                     "libxcb-dri3-dev", "libxcb-present-dev", "libxcb-composite0-dev", "libxcb-ewmh-dev",
                     "libxcb-res0-dev"], self.options.exclude_install), update=True, check=True)
        apt.install_substitutes(
            ["libxcb-util-dev"], ["libxcb-util0-dev"], update=True, check=True)

        yum = package_manager.Yum(self)
        yum.install(filter_list(["libxcb-devel", "libfontenc-devel", "libXaw-devel", "libXcomposite-devel",
                           "libXcursor-devel", "libXdmcp-devel", "libXtst-devel", "libXinerama-devel",
                           "libxkbfile-devel", "libXrandr-devel", "libXres-devel", "libXScrnSaver-devel",
                           "xcb-util-wm-devel", "xcb-util-image-devel", "xcb-util-keysyms-devel",
                           "xcb-util-renderutil-devel", "libXdamage-devel", "libXxf86vm-devel", "libXv-devel",
                           "xcb-util-devel", "libuuid-devel", "xcb-util-cursor-devel"], self.options.exclude_install), update=True, check=True)

        dnf = package_manager.Dnf(self)
        dnf.install(filter_list(["libxcb-devel", "libfontenc-devel", "libXaw-devel", "libXcomposite-devel",
                           "libXcursor-devel", "libXdmcp-devel", "libXtst-devel", "libXinerama-devel",
                           "libxkbfile-devel", "libXrandr-devel", "libXres-devel", "libXScrnSaver-devel",
                           "xcb-util-wm-devel", "xcb-util-image-devel", "xcb-util-keysyms-devel",
                           "xcb-util-renderutil-devel", "libXdamage-devel", "libXxf86vm-devel", "libXv-devel",
                           "xcb-util-devel", "libuuid-devel", "xcb-util-cursor-devel"], self.options.exclude_install), update=True, check=True)

        zypper = package_manager.Zypper(self)
        zypper.install(filter_list(["libxcb-devel", "libfontenc-devel", "libXaw-devel", "libXcomposite-devel",
                              "libXcursor-devel", "libXdmcp-devel", "libXtst-devel", "libXinerama-devel",
                              "libxkbfile-devel", "libXrandr-devel", "libXres-devel", "libXss-devel",
                              "xcb-util-wm-devel", "xcb-util-image-devel", "xcb-util-keysyms-devel",
                              "xcb-util-renderutil-devel", "libXdamage-devel", "libXxf86vm-devel", "libXv-devel",
                              "xcb-util-devel", "libuuid-devel", "xcb-util-cursor-devel"], self.options.exclude_install), update=True, check=True)

        pacman = package_manager.PacMan(self)
        pacman.install(filter_list(["libxcb", "libfontenc", "libice", "libsm", "libxaw", "libxcomposite", "libxcursor",
                              "libxdamage", "libxdmcp", "libxtst", "libxinerama", "libxkbfile", "libxrandr", "libxres",
                              "libxss", "xcb-util-wm", "xcb-util-image", "xcb-util-keysyms", "xcb-util-renderutil",
                              "libxxf86vm", "libxv", "xcb-util", "util-linux-libs", "xcb-util-cursor"], self.options.exclude_install), update=True, check=True)

        package_manager.Pkg(self).install(filter_list(["libX11", "libfontenc", "libice", "libsm", "libxaw", "libxcomposite", "libxcursor",
                           "libxdamage", "libxdmcp", "libxtst", "libxinerama", "libxkbfile", "libxrandr", "libxres",
                           "libXScrnSaver", "xcb-util-wm", "xcb-util-image", "xcb-util-keysyms", "xcb-util-renderutil",
                           "libxxf86vm", "libxv", "xkeyboard-config", "xcb-util", "xcb-util-cursor"], self.options.exclude_install), update=True, check=True)

    def package_info(self):
        if conan_version.major >= 2:
            self.cpp_info.bindirs = []
            self.cpp_info.includedirs = []
            self.cpp_info.libdirs = []

        components_list = filter_list(["x11", "x11-xcb", "fontenc", "ice", "sm", "xau", "xaw7",
                     "xcomposite", "xcursor", "xdamage", "xdmcp", "xext", "xfixes", "xi",
                     "xinerama", "xkbfile", "xmu", "xmuu", "xpm", "xrandr", "xrender", "xres",
                     "xscrnsaver", "xt", "xtst", "xv", "xxf86vm",
                     "xcb-xkb", "xcb-icccm", "xcb-image", "xcb-keysyms", "xcb-randr", "xcb-render",
                     "xcb-renderutil", "xcb-shape", "xcb-shm", "xcb-sync", "xcb-xfixes",
                     "xcb-xinerama", "xcb", "xcb-atom", "xcb-aux", "xcb-event", "xcb-util",
                     "xcb-dri3", "xcb-cursor", "xcb-dri2", "xcb-dri3", "xcb-glx", "xcb-present",
                     "xcb-composite", "xcb-ewmh", "xcb-res"] + ([] if self.settings.os == "FreeBSD" else ["uuid"]), self.options.exclude_lib)
        for name in components_list:
            pkg_config = PkgConfig(self, name)
            pkg_config.fill_cpp_info(
                self.cpp_info.components[name], is_system=self.settings.os != "FreeBSD")
            self.cpp_info.components[name].version = pkg_config.version
            self.cpp_info.components[name].set_property(
                "pkg_config_name", name)
            self.cpp_info.components[name].set_property(
                "component_version", pkg_config.version)
            self.cpp_info.components[name].bindirs = []
            self.cpp_info.components[name].includedirs = []
            self.cpp_info.components[name].libdirs = []
            self.cpp_info.components[name].set_property("pkg_config_custom_content",
                                                        "\n".join(f"{key}={value}" for key, value in pkg_config.variables.items() if key not in ["pcfiledir","prefix", "includedir"]))

        if self.settings.os == "Linux":
            self.cpp_info.components["sm"].requires.append("uuid")
