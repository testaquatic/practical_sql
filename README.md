# 실용 SQL

- 저자 깃허브
  [https://github.com/anthonydb/practical-sql-2](https://github.com/anthonydb/practical-sql-2)
- 번역자 깃허브
  [https://github.com/TeeDDub/practical-sql](https://github.com/TeeDDub/practical-sql)
- 책 정보
  [https://product.kyobobook.co.kr/detail/S000200642129](https://product.kyobobook.co.kr/detail/S000200642129)

코딩에 대한 책을 읽다보니 SQL에 대해서 언급이 많이 나와서 구입했다.

# Postgres

```bash
docker run -d \
 --name practical-sql-db \
 -p 25432:5432 \
 -e POSTGRES_PASSWORD=postgres \
 -e POSTGRES_DB=analysis \
 -v practical-sql-db-data:/var/lib/postgresql \
 postgis/postgis:18-master
```
