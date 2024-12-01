
# escape=`
FROM mcr.microsoft.com/windows/nanoserver:1809 AS installer

# Gerekli dosyaları kopyala
COPY docs/7z.dll C:\7z.dll
COPY docs/7z.exe C:\7z.exe
COPY docs/caddy.7z C:\caddy.7z

FROM mcr.microsoft.com/windows/nanoserver:1809

COPY --from=installer C:\7z.exe C:\7z.exe
COPY --from=installer C:\7z.dll C:\7z.dll

WORKDIR C:\caddy
COPY --from=installer C:\caddy.7z C:\caddy.7z
RUN C:\7z.exe x C:\caddy.7z -oC:\caddy && del C:\caddy.7z

WORKDIR C:\caddy\html
RUN pwsh.exe -Command "Remove-Item C:\caddy\html\* -Recurse -Force"
COPY src/* C:\caddy\html\

COPY docs/caddyfile.template C:\caddy\Caddyfile

EXPOSE 80 443

WORKDIR C:\caddy
RUN /caddy.exe run --config /Caddyfile
