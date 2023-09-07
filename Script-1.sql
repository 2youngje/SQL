--basic
--coustomer ���̺��� Country Į���� �ߺ����� ����غ�����
SELECT Name || '����' FROM genres;

--customers ���̺��� Country Į���� �ߺ����� ����غ�����
SELECT DISTINCT Country FROM customers;

--tracks ���̺��� MillisecondsĮ���� 1000�� ������ Seconds Į�������� ������ּ���.
SELECT Milliseconds /1000 as Seconds FROM  tracks;


--�Լ�
--1. artists ���̺��� Name Į���� �빮�ڷ� ������ּ���.
SELECT UPPER(name) from artists 

--2. tracks ���̺��� �� �̸��� �����Ͽ� ���̸� ������ּ���.
SELECT LENGTH(Name) as "����" FROM tracks

--3. invoices ���̺��� û������ �� �ݾ��� �ݿø��� ����� ǥ��
SELECT ROUND(Total) FROM invoices


--4. tracks ���̺��� ���� ����(Milliseconds)�� �ݿø� �� ���� �� ������ ���� ���̸� ǥ��
SELECT ROUND(Milliseconds/1000/60) as minutes FROM tracks

--5.invoices ���̺��� û������ �� �ݾ�(Total)�� ���� �ݾ� ������ �з�(Total ���� 10 ���ϸ� '����', 10 �ʰ� 50 ���ϸ� '����', 50 �ʰ��� '����'���� �з�
SELECT Total,
	CASE 
		WHEN Total < 10 THEN "����"
		WHEN 10<Total< 50 THEN "����"
		WHEN Total > 50 THEN "����"
	END
FROM invoices i 

--where
--1. customers ���̺��� ���� "USA"�� ������ ������ ����
SELECT * FROM customers WHERE Country = "USA"

--2. employees ���̺��� ������� 2003�� ������ �������� ������ ����
SELECT * FROM  employees WHERE HireDate < '2003-01-01'

--3. albums ���̺��� �ٹ� ���� "Love"��� �ܾ ���Ե� �ٹ����� ������ ����
SELECT * FROM  albums WHERE Title LIKE "%Love%"

--group by, having
SELECT Id, SUM(numb)
FROM Table
GROUP BY Id

-- 1.customers ���̺��� �� ���󺰷� �� ���� 5�� �̻��� ������� ������ ����
SELECT Country as '����', count(CustomerId) as '����'
FROM customers c
GROUP BY Country
HAVING COUNT(CustomerId) >= 5 

-- 2.tracks ���̺��� �� �帣���� �� ���� 100�� �̻��� �帣�� ����
SELECT GenreId,COUNT(TrackId) 
FROM tracks
GROUP BY GenreId
HAVING count(TrackId) >= 100 

-- 3.tracks ���̺��� �� ���� �帣���� ��� ���̰� 300000 �и���(5��) �̻� ���帣�� ����
SELECT GenreId as '�帣', AVG(Milliseconds) as '��� ����'
from tracks
group by GenreId
HAVING AVG(Milliseconds) > 300000

-- 4.invoices ���̺��� �� ������ �� ���� �ݾ��� 40�޷� �̻��� ���� ����
SELECT CustomerId, sum(Total)
FROM invoices
group by CustomerId
HAVING SUM(Total) >= 40

-- 5. tracks ���̺��� �� �ٹ��� Ʈ�� ���� 15�� �̻��� �ٹ��� ����
SELECT AlbumId as '�ٹ�' , count(AlbumId) as 'Ʈ�� ��'
FROM tracks
GROUP BY AlbumId 
HAVING COUNT(AlbumId) >= 15; 


--order by
--1. artists ���̺��� ��Ƽ��Ʈ �̸��� ���ĺ� ������ ����
SELECT * from artists order by Name ASC;
--2. tracks ���̺��� �� ���̸� ������������ �����Ͽ� ����
SELECT * FROM tracks order by LENGTH(Name) ASC;
--3. invoices ���̺��� û������ �� �ݾ��� ������������ �����Ͽ� ����
SELECT * FROM invoices order by Total DESC ;

--join
SELECT * 
FROM invoices as i
JOIN customers as c ON
	i.CustomerId = c.CustomerId;
	
--JOIN �ǽ�
--1. customers�� invoices�� ���̺��� �����Ͽ� �� ���� �̸��� ������ û������ �ѱݾ��� ����
select c.FirstName ||' '|| c.LastName as FullName, sum(i.Total)
FROM customers c 
join invoices i on
	c.CustomerId = i.CustomerId
GROUP BY c.CustomerId
HAVING SUM(i.Total)
ORDER BY sum(i.Total) desc;
--2. employees�� customers ���̺��� �����Ͽ� �� ������ �� ������ ����� �� ��������
SELECT e.EmployeeId as '����ID' , count(*) as '����' 
FROM employees e left join customers c 
where e.EmployeeId = c.SupportRepId 
GROUP BY e.EmployeeId ;
--3. albums, tracks, �׸��� genres ���̺��� �����Ͽ� �� �ٹ��� ����, �� ��, �׸����帣 �̸��� ����
SELECT a.Title as '����', COUNT(t.TrackId) as '�� ��', g.Name  as '�帣' 
FROM albums a 
join tracks t on a.AlbumId = t.AlbumId
JOIN genres g on g.GenreId = t.GenreId
GROUP BY a.Title
