Name:           lavanda-kde-theme
Version:        1.1.0
Release:        1%{?dist}
Summary:        Lavanda theme suite for KDE Plasma 6

License:        GPL-3.0-or-later
URL:            https://github.com/WenYin-Community/Lavanda-kde-theme
Source0:        %{url}/releases/download/v%{version}/Lavanda-kde-theme-%{version}.tar.gz

BuildArch:      noarch
# Only Fedora chroots compile SDDM translations; EPEL builds skip them.
%if 0%{?fedora}
BuildRequires:  qt6-linguist
%endif

Recommends:     kvantum
Supplements:    (sddm and plasma-workspace)

%global sddm_themedir %{_datadir}/sddm/themes

%description
Lavanda theme suite for KDE Plasma 6: Aurorae window decorations with
macOS-style traffic-light buttons, Plasma desktop themes and global themes,
color schemes, Kvantum widget themes, SDDM greeter themes (with zh_CN
localization) and wallpapers.

Requires Plasma 6.1+ (Qt 6.5+). Tested with Plasma 6.8, Qt 6.11 and
SDDM 0.21.

%prep
%autosetup -n Lavanda-kde-theme-%{version}

%build
# Compile SDDM translations (.ts -> .qm); skipped when no lrelease (EPEL).
for d in sddm/6.0/Lavanda sddm/6.0/Lavanda-Sea; do
  for ts in "$d"/translations/*.ts; do
    [ -e "$ts" ] || continue
    if command -v lrelease-qt6 >/dev/null 2>&1; then
      lrelease-qt6 "$ts"
    elif command -v lrelease >/dev/null 2>&1; then
      lrelease "$ts"
    fi
  done
done

%install
D=%{buildroot}
install -d "$D"%{_datadir}/aurorae/themes \
           "$D"%{_datadir}/color-schemes \
           "$D"%{_datadir}/plasma/desktoptheme \
           "$D"%{_datadir}/plasma/look-and-feel \
           "$D"%{_datadir}/Kvantum \
           "$D"%{_datadir}/wallpapers \
           "$D"%{sddm_themedir}

for theme in '' '-Sea'; do
  for color in '-Light' '-Dark'; do
    variant="Lavanda${theme}${color}"
    if [ -n "$theme" ]; then else_theme='Sea'; else else_theme=''; fi
    if [ "$color" = '-Dark' ]; then else_color='Dark'; else else_color='Light'; fi
    scheme="Lavanda${else_theme}${else_color}.colors"

    cp -a "aurorae/$variant"               "$D"%{_datadir}/aurorae/themes/
    install -m 644 "color-schemes/$scheme" "$D"%{_datadir}/color-schemes/
    cp -a "Kvantum/Lavanda${else_theme}"   "$D"%{_datadir}/Kvantum/

    PT="$D"%{_datadir}/plasma/desktoptheme/"$variant"
    cp -a "plasma/desktoptheme/$variant" "$PT"
    cp -a plasma/desktoptheme/icons "$PT/icons"
    if [ -n "$theme" ]; then
      cp -a plasma/desktoptheme/icons-Sea/. "$PT/icons/"
    fi
    install -m 644 "color-schemes/$scheme" "$PT/colors"
    install -d "$PT/wallpapers"
    cp -a "wallpaper/$variant" "$PT/wallpapers/"

    cp -a "plasma/look-and-feel/com.github.vinceliuice.$variant" \
          "$D"%{_datadir}/plasma/look-and-feel/
    cp -a "wallpaper/$variant"       "$D"%{_datadir}/wallpapers/
    cp -a "wallpaper/Lavanda$theme"  "$D"%{_datadir}/wallpapers/
  done
done

cp -a sddm/6.0/Lavanda     "$D"%{sddm_themedir}/Lavanda
cp -a sddm/6.0/Lavanda-Sea "$D"%{sddm_themedir}/Lavanda-Sea

# Optional user-level white logout override: shipped as data, the user
# enables it by running the packaged install.sh (no sudo, touches $HOME only).
install -d "$D"%{_datadir}/lavanda-kde-theme
cp -a logout-white "$D"%{_datadir}/lavanda-kde-theme/logout-white

%files
%doc README.md AUTHORS
%license LICENSE
%{_datadir}/aurorae/themes/Lavanda-*
%{_datadir}/color-schemes/Lavanda*.colors
%{_datadir}/Kvantum/Lavanda*
%{_datadir}/plasma/desktoptheme/Lavanda-*
%{_datadir}/plasma/look-and-feel/com.github.vinceliuice.Lavanda-*
%{_datadir}/wallpapers/Lavanda*
%{sddm_themedir}/Lavanda
%{sddm_themedir}/Lavanda-Sea
%{_datadir}/lavanda-kde-theme

%changelog
* Tue Nov 10 2026 Wenyin Root <wenyin@ruojiner.cn> - 1.1.0-1
- Upstream adds install-freebsd.sh (POSIX sh installer for FreeBSD,
  user-level and system-wide install/uninstall).

* Wed Nov 04 2026 Wenyin Root <wenyin@ruojiner.cn> - 1.0.2-1
- Ship the optional logout-white user-level override as data under
  /usr/share/lavanda-kde-theme/logout-white for RPM users to enable.

* Wed Nov 04 2026 Wenyin Root <wenyin@ruojiner.cn> - 1.0.1-1
- Initial package: Aurorae decorations with macOS traffic-light buttons,
  Plasma desktop/global themes, color schemes, Kvantum, SDDM, wallpapers.
