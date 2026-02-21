sqlite3 ~/.local/share/qutebrowser/webengine/Cookies "
SELECT '# Netscape HTTP Cookie File';
SELECT
  host_key AS host,
  CASE WHEN host_key LIKE '.%' THEN 'TRUE' ELSE 'FALSE' END,
  path,
  CASE WHEN is_secure != 0 THEN 'TRUE' ELSE 'FALSE' END,
  ((expires_utc/1000000)-11644473600) AS expiry,
  name,
  value
FROM cookies
WHERE (host_key LIKE '%youtube.com' OR host_key LIKE '%googlevideo.com' OR host_key LIKE '%ytimg.com')
  AND expires_utc > strftime('%s', 'now') * 1000000
ORDER BY creation_utc;
" -separator $'\t' > "$HOME/.local/share/yt-dlp-cookies.txt"
