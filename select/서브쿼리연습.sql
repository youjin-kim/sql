-- ex) (현재 Fai Bale이 근무하는 부서)에서 근무하는 (직원의 사번, 전체이름)을 출력해보세요.
-- sol 1-1)
select a.dept_no 
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and to_date = '9999-01-01'
   and concat(b.first_name, ' ', b.last_name) like 'Fai Bale';
-- sol 1-2)
select b.emp_no, concat(b.first_name, ' ', b.last_name)
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and to_date = '9999-01-01'
   and a.dept_no = 'd004';  
   
-- sol subquery를 사용)
select b.emp_no, concat(b.first_name, ' ', b.last_name)
  from dept_emp a, employees b
 where a.emp_no = b.emp_no
   and to_date = '9999-01-01'
   and a.dept_no = (select a.dept_no 
					  from dept_emp a, employees b
					 where a.emp_no = b.emp_no
					   and to_date = '9999-01-01'
					   and concat(b.first_name, ' ', b.last_name) = 'Fai Bale');  

-- 서브쿼리는 괄호로 묶여야 함
-- 서브쿼리 내에 order by 금지
-- group by  절에 외에 거의 모든 절에서 사용가능(특히, from절, where절에 많이 사용)
-- where 절인 경우,
--   1) 단일행 연산자: =, >, <, >=, <=, <>


-- 실습문제1)
-- 현재 전체사원의 평균 연봉보다 적은 급여를 받는 사원의 이름, 급여를 나타내세요.
select a.first_name, b.salary  
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.to_date = '9999-01-01'
   and salary < ( select avg(salary)
                    from salaries
				   where to_date='9999-01-01');

-- 실습문제2)
-- 현재 가장적은 평균급여를 받고 있는 직책에 대해서 평균급여를 구하세요

-- 방법1: Top-K 를 사용
  select b.title, avg(a.salary)
    from salaries a, titles b
   where a.emp_no = b.emp_no
     and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by b.title
  having round(avg(a.salary)) = (  select round(avg(a.salary))
                                     from salaries a, titles b
                                    where a.emp_no = b.emp_no
                                      and a.to_date = '9999-01-01'
                                      and b.to_date = '9999-01-01'
                                 group by b.title
                                 order by avg(a.salary) asc
                                    limit 0, 1);

-- 방법2: from절 서브쿼리 및 집계 min 함수를 사용
  select b.title, avg(a.salary)
    from salaries a, titles b
   where a.emp_no = b.emp_no
     and a.to_date = '9999-01-01'
     and b.to_date = '9999-01-01'
group by b.title
  having round(avg(a.salary)) = (select min(a.avg_salary)
								   from (select round(avg(a.salary)) as avg_salary
                                            from salaries a, titles b
                                           where a.emp_no = b.emp_no
                                             and a.to_date = '9999-01-01'
                                             and b.to_date = '9999-01-01'
                                          group by b.title) a );
                                          
-- 방법3: join으로 만 풀기 (굳이 서브쿼리를 쓸 필요가 없다)
select avg(a.salary)
	from salaries a, titles b
    where a.emp_no = b.emp_no
	  and a.to_date = '9999-01-01'
      and b.to_date = '9999-01-01'
      group by b.title
      order by avg(a.salary) asc
      limit 0, 1;
      
-- where 절인 경우
-- 2) 다중(복수)행 연산자 : in, not in, any, all     //in, not in 은 단독 사용 가능
--  2-1) any 사용법
--       1. =any : in와 완전동일
--       2. >any, >=any : 최소값
--       3. <any, <=any : 최대값
--       4. <>any, !=any : !=all 와 동일
--  2-2) all 사용법
--       1. =all : in와 완전동일
--       2. >all, >=all : 최대값
--       3. <all, <=all : 최소값

-- 실습문제3) 
-- 현재 급여가 50000 이상인 직원 이름 출력

-- 방법1: join으로 만 풀기
select concat(a.first_name, ' ', a.last_name) as name
	from employees a, salaries b
    where a.emp_no = b.emp_no
      and b.to_date = '9999-01-01'
      and b.salary > 50000;

-- 방법2: in
select concat(a.first_name, ' ', a.last_name) as name
	from employees a
    where a.emp_no in (select emp_no
						from salaries
						where to_date = '9999-01-01'
						and salary > 50000);

-- 방법3: =any
select concat(a.first_name, ' ', a.last_name) as name
	from employees a
    where a.emp_no =any (select emp_no
						from salaries
						where to_date = '9999-01-01'
						and salary > 50000);

-- 실습문제4) 각 부서별로 최고월급을 받는 직원의 이름과 월급을 출력하시오. dept_no, first_name, max_salary
 select a.first_name, c.dept_no, b.salary as max_salary
   from employees a, salaries b, dept_emp c, (select c.dept_no, max(b.salary) as max_salary
													from employees a, salaries b, dept_emp c
													where a.emp_no = b.emp_no
													and a.emp_no = c.emp_no
													and b.to_date = '9999-01-01'
													and c.to_date = '9999-01-01'
													group by c.dept_no) d
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
     and c.dept_no = d.dept_no
     and b.salary = d.max_salary
     and b.to_date = '9999-01-01'
     and c.to_date = '9999-01-01';


