install_data(
    ['com.github.jeremypw.gpg-wrapper_encrypt.contract', 'com.github.jeremypw.gpg-wrapper_decrypt.contract'],
    install_dir: join_paths(get_option('datadir'), 'contractor')
)

i18n.merge_file (
    'appdata',
    input: meson.project_name () + '.appdata.xml.in',
    output: meson.project_name () + '.appdata.xml',
    install: true,
    install_dir: join_paths (get_option ('datadir'), 'metainfo'),
    po_dir: join_paths (meson.source_root (), 'po'),
    type: 'xml'
)

test (
    'Validate appdata file',
    find_program ('appstreamcli'),
    args: ['validate', '--pedantic', join_paths (meson.current_build_dir (), meson.project_name () + '.appdata.xml')]
)
