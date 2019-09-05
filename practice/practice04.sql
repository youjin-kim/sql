-- <문제1> : 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?   72012.2359
select count(emp_no)
	from salaries
    where salary > ( select avg(salary) 
						from salaries
                        where to_date = '9999-01-01')
      and to_date = '9999-01-01';

-- <문제 2번> :  현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 
-- 				단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 
select b.emp_no as 사번, concat(b.first_name, ' ', b.last_name) as 이름, d.dept_name as 부서, max(a.salary) as 연봉 
	from salaries a, employees b, dept_emp c, departments d
    where b.emp_no = a.emp_no
      and b.emp_no = c.emp_no
      and c.dept_no = d.dept_no
      and a.to_date = '9999-01-01'
      and c.to_date = '9999-01-01'
      group by d.dept_no
      order by max(a.salary) desc;
      
-- <문제 3번> :  현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요.
select a.emp_no, concat(a.first_name, ' ', a.last_name) as name, c.salary, b.dept_no
	from employees a, dept_emp b, salaries c, ( select b.dept_no, avg(c.salary) as avg_salary
												from employees a, dept_emp b, salaries c
												where a.emp_no = b.emp_no
												  and a.emp_no = c.emp_no
												  and b.to_date = '9999-01-01'
												  and c.to_date = '9999-01-01'
												  group by dept_no ) d
    where a.emp_no = b.emp_no
      and a.emp_no = c.emp_no
      and b.dept_no = d.dept_no
      and b.to_date = '9999-01-01'
      and c.to_date = '9999-01-01'
      and c.salary > d.avg_salary
      order by b.dept_no;
	
-- <문제 4번> :  현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.
select a.emp_no, concat(a.first_name, ' ', a.last_name) as name, d.manager_name , c.dept_name
	from employees a, dept_emp b, departments c, (select concat(a.first_name, ' ', a.last_name) as manager_name, b.dept_no
																	from employees a, dept_manager b
																	where a.emp_no = b.emp_no
																	  and b.to_date = '9999-01-01') d
    where a.emp_no = b.emp_no
      and b.dept_no = c.dept_no
	  and b.dept_no = d.dept_no
      and b.to_date = '9999-01-01'
      order by dept_name;
      
-- <문제 5번> :  현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.
 select a.emp_no, concat(a.first_name, ' ', a.last_name) as name, c.title, b.salary, d.dept_no
	from employees a, salaries b, titles c, dept_emp d
    where a.emp_no = b.emp_no
      and a.emp_no = c.emp_no
      and a.emp_no = d.emp_no
      and b.to_date = '9999-01-01'
      and c.to_date = '9999-01-01'
      and d.to_date = '9999-01-01'
      and d.dept_no = (select c.dept_no
						from employees a, salaries b, dept_emp c
						where a.emp_no = b.emp_no
						  and a.emp_no = c.emp_no
						  and b.to_date = '9999-01-01'
						  and c.to_date = '9999-01-01'
						  group by c.dept_no
						  order by avg(b.salary) desc
						  limit 1)
	 order by b.salary desc;

-- <문제 6번> :  평균 연봉이 가장 높은 부서는? 
select d.dept_name
	from employees a, salaries b, dept_emp c, departments d
	where a.emp_no = b.emp_no
	  and a.emp_no = c.emp_no
      and c.dept_no = d.dept_no
	  and b.to_date = '9999-01-01'
	  and c.to_date = '9999-01-01'
	  group by c.dept_no
	  order by avg(b.salary) desc
	  limit 0, 1;

-- <문제 7번> :  평균 연봉이 가장 높은 직책은? 
select b.title
	from salaries a, titles b
    where a.emp_no = b.emp_no
	  and a.to_date = '9999-01-01'
      and b.to_date = '9999-01-01'
      group by b.title
      order by avg(a.salary) desc
	  limit 0, 1;

-- <문제 8번> :  현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 				부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.      
select c.dept_name, concat(a.first_name, ' ', a.last_name) as name, d.salary, e.manager_name, e.manager_salary
	from employees a, dept_emp b, departments c, salaries d, (select concat(a.first_name, ' ', a.last_name) as manager_name, b.dept_no, c.salary as manager_salary
																from employees a, dept_manager b, salaries c
																where a.emp_no = b.emp_no
																  and a.emp_no = c.emp_no
																  and b.to_date = '9999-01-01'
																  and c.to_date = '9999-01-01') e
    where a.emp_no = b.emp_no
      and a.emp_no = d.emp_no
      and b.dept_no = c.dept_no
      and b.dept_no = e.dept_no
      and b.to_date = '9999-01-01'
      and d.to_date = '9999-01-01'
      and d.salary > e.manager_salary
      group by a.emp_no
      order by c.dept_name;
      