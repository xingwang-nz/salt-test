{% set api_doc_niginx_files_root_folder = '/usr/share/nginx/ics-api-doc' %}

# create api-doc niginx files root folder
create-api-doc-niginx-file-root:
  file.directory:
    - name: {{ api_doc_niginx_files_root_folder }}
    - mode: 755
    - makedirs: True

# create api-doc niginx files root folder
copy-api-doc-files:
  file.recurse:
    - name: {{ api_doc_niginx_files_root_folder }}
    - source: salt://api-doc-files
    - include_empty: True      