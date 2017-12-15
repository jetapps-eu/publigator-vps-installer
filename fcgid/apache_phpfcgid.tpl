<VirtualHost %ip%:%web_port%>

    ServerName %domain_idn%
    %alias_string%
    ServerAdmin %email%
    DocumentRoot %docroot%
    ScriptAlias /cgi-bin/ %home%/%user%/web/%domain%/cgi-bin/
    Alias /vstats/ %home%/%user%/web/%domain%/stats/
    Alias /error/ %home%/%user%/web/%domain%/document_errors/
    SuexecUserGroup %user% %group%
    CustomLog /var/log/httpd/domains/%domain%.bytes bytes
    CustomLog /var/log/httpd/domains/%domain%.log combined
    ErrorLog /var/log/httpd/domains/%domain%.error.log
    FcgidBusyTimeout 900
    FcgidIdleTimeout 900
    FcgidIOTimeout   900
    FcgidMaxRequestLen 104857600
    FcgidMaxRequestInMem 128000000
    FcgidMaxRequestsPerProcess 1000
    <Directory %docroot%>
        AllowOverride All
        Options +Includes -Indexes +ExecCGI
        <Files *.php>
          SetHandler fcgid-script
        </Files>
        FCGIWrapper %home%/%user%/web/%domain%/cgi-bin/fcgi-starter .php
    </Directory>
    <Directory %home%/%user%/web/%domain%/stats>
        AllowOverride All
    </Directory>
    Include %home%/%user%/conf/web/httpd.%domain%.conf*

</VirtualHost>

