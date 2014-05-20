{% from "postgres/map.jinja" import postgres with context %}

include:
  - postgres

pg_hba.conf:
  file.managed:
    - name: {{ postgres.pg_hba }}
    - source: {{ salt['pillar.get']('postgres:lookup:pg_hba_conf', 'salt://postgres/files/pg_hba.conf' }}
    - template: jinja
    - user: postgres
    - group: postgres
    - mode: 644
    - require:
      - pkg: {{ postgres.pkg }}
    - watch_in:
      - service: postgresql
