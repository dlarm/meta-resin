# Add custom resin fields
OS_RELEASE_FIELDS_append = " RESIN_BOARD_REV META_RESIN_REV"

# Simplify VERSION output
VERSION = "${DISTRO_VERSION}"

# Generate RESIN_BOARD_REV and META_RESIN_REV
python __anonymous () {
    import subprocess

    version = d.getVar("VERSION", True)
    bblayers = d.getVar("BBLAYERS", True)

    # Detect the path of meta-resin-common
    metaresincommonpath = filter(lambda x: x.endswith('meta-resin-common'), bblayers.split())

    if metaresincommonpath:
        resinboardpath = os.path.join(metaresincommonpath[0], '../../')
        metaresinpath = os.path.join(metaresincommonpath[0], '../')

        cmd = 'git log -n1 --format=format:%h '
        resinboardrev = subprocess.Popen('cd ' + resinboardpath + ' ; ' + cmd, stdout=subprocess.PIPE, shell=True).communicate()[0]
        metaresinrev = subprocess.Popen('cd ' + metaresinpath + ' ; ' + cmd, stdout=subprocess.PIPE, shell=True).communicate()[0]

        if resinboardrev:
            d.setVar('RESIN_BOARD_REV', resinboardrev)
        if metaresinrev:
            d.setVar('META_RESIN_REV', metaresinrev)
    else:
        bb.warn("Cannot get the revisions of your repositories.")
}
