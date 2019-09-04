select avg(salary), sum(salary)
	from salaries
    where emp_no = '10060';
    
select emp_no, avg(salary), sum(salary)
	from salaries
    where to_date = '9999-01-01'
    group by emp_no
    having avg(salary) > 40000
    order by avg(salary);
    
-- ex1) 각 사원별로 평균연봉 출력
select emp_no, avg(salary)
	from salaries
    group by emp_no
    order by avg(salary) desc;
    
select title
	from titles
    where emp_no = 109334;
    
    
-- 과제) 각 현재 Manager 직책 사원에 대한 평균 연봉은?
select avg(a.salary)
	from salaries a, titles b
    where a.emp_no = b.emp_no        -- join 조건
    and a.to_date = '9999-01-01'     -- row 선택 조건1 
    and b.to_date = '9999-01-01'     -- row 선택 조건2
    and b.title = 'Manager';         -- row 선택 조건3

-- 과제) 각 현재 직책별 사원에 대한 평균 연봉은?
select b.title, avg(a.salary)
	from salaries a, titles b
    where a.emp_no = b.emp_no        -- join 조건
    and a.to_date = '9999-01-01'     -- row 선택 조건1 
    and b.to_date = '9999-01-01'     -- row 선택 조건2
    group by b.title         -- row 선택 조건3
    order by avg(salary) desc;

-- ex3) 사원별 몇 번의 직책 변경이 있었는지 조회
select emp_no, count(*)
	from titles
    group by emp_no
    order by count(*) desc;
    
-- ex4) 각 사원별 평균연봉을 출력하되 50,000불 이상인 직원만 출력
select emp_no, avg(salary)
	from salaries
    group by emp_no
    having avg(salary) >= 50000
    order by avg(salary) desc;
    
-- 과제) 현재 직책별로 평균 연봉과 인원수를 구하되 직책별로 인원이 100명 이상인 직책만 출력하시오.
select a.title, avg(b.salary) as '평균 연봉', count(a.emp_no) as '인원수'
	from titles a, salaries b
    where a.emp_no = b.emp_no
      and a.to_date = '9999-01-01'
      and b.to_date = '9999-01-01'
      group by a.title
      having count(a.emp_no) > 100;

-- 과제) 현재 부서별로 현재 직책이 Engineer인 직원들에 대해서만 평균급여를 구하시오.
select a.title, avg(b.salary) as '평균 급여'
	from titles a, salaries b
    where a.emp_no = b.emp_no
	  and a.to_date = '9999-01-01'
      and b.to_date = '9999-01-01'
      and a.title like '%Engineer'
      group by a.title;

-- 과제) 현재 직책별로 급여의 총합을 구하되 Engineer직책은 제외하고
-- 		단, 총합이 2,000,000,000이상인 직책만 나타내며 급여총합에 대해서 desc로 정렬하시오.
select a.title, sum(b.salary)
	from titles a, salaries b
    where a.emp_no = b.emp_no
     and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
     and a.title != 'Engineer'
     group by a.title
     having sum(b.salary) > 2000000000
     order by sum(b.salary) desc;
     