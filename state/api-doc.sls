{% set api_doc_niginx_files_root_folder = '/usr/share/nginx/api-doc' %}

# create api-doc niginx files root folder
create-api-doc-niginx-file-root:
  file.directory:
    - name: {{ api_doc_niginx_files_root_folder }}
    - mode: 755
    - makedirs: True
    - recurse:
      - user
      - group

# create api-doc niginx files root folder
copy-api-doc-files:
  file.recurse:
    - source: salt://api-doc-files
    - include_empty: True      