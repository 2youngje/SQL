--basic
--coustomer 테이블에서 Country 칼럼을 중복없이 출력해보세요
SELECT Name || '음악' FROM genres;

--customers 테이블에서 Country 칼럼을 중복없이 출력해보세요
SELECT DISTINCT Country FROM customers;

--tracks 테이블에서 Milliseconds칼럼에 1000을 나누어 Seconds 칼럼명으로 출력해주세요.
SELECT Milliseconds /1000 as Seconds FROM  tracks;


--함수
--1. artists 테이블에서 Name 칼럼을 대문자로 출력해주세요.
SELECT UPPER(name) from artists 

--2. tracks 테이블에서 곡 이름을 추출하여 길이를 출력해주세요.
SELECT LENGTH(Name) as "길이" FROM tracks

--3. invoices 테이블에서 청구서의 총 금액을 반올림한 결과를 표시
SELECT ROUND(Total) FROM invoices


--4. tracks 테이블에서 곡의 길이(Milliseconds)를 반올림 한 다음 분 단위로 곡의 길이를 표시
SELECT ROUND(Milliseconds/1000/60) as minutes FROM tracks

--5.invoices 테이블에서 청구서의 총 금액(Total)에 따라서 금액 범위를 분류(Total 값이 10 이하면 '낮음', 10 초과 50 이하면 '보통', 50 초과면 '높음'으로 분류
SELECT Total,
	CASE 
		WHEN Total < 10 THEN "낮음"
		WHEN 10<Total< 50 THEN "보통"
		WHEN Total > 50 THEN "높음"
	END
FROM invoices i 

--where
--1. customers 테이블에서 나라가 "USA"인 고객들의 정보를 선택
SELECT * FROM customers WHERE Country = "USA"

--2. employees 테이블에서 고용일이 2003년 이전인 직원들의 정보를 선택
SELECT * FROM  employees WHERE HireDate < '2003-01-01'

--3. albums 테이블에서 앨범 제목에 "Love"라는 단어가 포함된 앨범들의 정보를 선택
SELECT * FROM  albums WHERE Title LIKE "%Love%"

--group by, having
SELECT Id, SUM(numb)
FROM Table
GROUP BY Id

-- 1.customers 테이블에서 각 나라별로 고객 수가 5명 이상인 나라들의 정보를 선택
SELECT Country as '나라', count(CustomerId) as '고객수'
FROM customers c
GROUP BY Country
HAVING COUNT(CustomerId) >= 5 

-- 2.tracks 테이블에서 곡 장르별로 곡 수가 100개 이상인 장르를 선택
SELECT GenreId,COUNT(TrackId) 
FROM tracks
GROUP BY GenreId
HAVING count(TrackId) >= 100 

-- 3.tracks 테이블에서 각 곡의 장르별로 평균 길이가 300000 밀리초(5분) 이상 인장르를 선택
SELECT GenreId as '장르', AVG(Milliseconds) as '평균 길이'
from tracks
group by GenreId
HAVING AVG(Milliseconds) > 300000

-- 4.invoices 테이블에서 각 고객별로 총 구매 금액이 40달러 이상인 고객을 선택
SELECT CustomerId, sum(Total)
FROM invoices
group by CustomerId
HAVING SUM(Total) >= 40

-- 5. tracks 테이블에서 각 앨범의 트랙 수가 15개 이상인 앨범을 선택
SELECT AlbumId as '앨범' , count(AlbumId) as '트랙 수'
FROM tracks
GROUP BY AlbumId 
HAVING COUNT(AlbumId) >= 15; 


--order by
--1. artists 테이블에서 아티스트 이름을 알파벳 순으로 정렬
SELECT * from artists order by Name ASC;
--2. tracks 테이블에서 곡 길이를 오름차순으로 정렬하여 선택
SELECT * FROM tracks order by LENGTH(Name) ASC;
--3. invoices 테이블에서 청구서의 총 금액을 내림차순으로 정렬하여 선택
SELECT * FROM invoices order by Total DESC ;

--join
SELECT * 
FROM invoices as i
JOIN customers as c ON
	i.CustomerId = c.CustomerId;
	
--JOIN 실습
--1. customers와 invoices을 테이블을 조인하여 각 고객의 이름과 구매한 청구서의 총금액을 선택
select c.FirstName ||' '|| c.LastName as FullName, sum(i.Total)
FROM customers c 
join invoices i on
	c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING SUM(i.Total)
ORDER BY sum(i.Total) desc;
--2. employees와 customers 테이블을 조인하여 각 직원과 그 직원이 담당한 고객 수를선택
SELECT e.EmployeeId as '직원ID' , count(*) as '고객수' 
FROM employees e left join customers c 
where e.EmployeeId = c.SupportRepId 
GROUP BY e.EmployeeId ;
--3. albums, tracks, 그리고 genres 테이블을 조인하여 각 앨범의 제목, 곡 수, 그리고장르 이름을 선택
SELECT a.Title as '제목', COUNT(t.TrackId) as '곡 수', g.Name  as '장르' 
FROM albums a 
join tracks t on a.AlbumId = t.AlbumId
JOIN genres g on g.GenreId = t.GenreId
GROUP BY a.Title
