use hr;

-- --------------------------------------------------------
-- 서브쿼리
-- --------------------------------------------------------

-- 사번이 112인 사원과 같은 부서에 근무하는 사원 정보를 조회하시오.
-- 사번, 부서번호, 입사일자

select department_id
from employees
where employee_id = 112;


select department_id
from employees
where employee_id = 112;

                       
select *
from employees
where department_id = (select department_id
			           from employees
                       where employee_id = 112);
                       

-- --------------------------------------------------------
-- 단힝랳 서브쿼리 
-- 하나의 행을 반환
-- 비교 연산자 (=, > <, >= ...)
-- --------------------------------------------------------
                       
select *
from employees
where department_id = (select department_id
			           from employees
                       where employee_id = 112);

                       
select *
from employees
where job_id = (select job_id
			    from employees
                where employee_id = 112);
                       
                       
                       
-- 사번이 112인 사원보다 급여를 많이 받는 사원 정보를 조회하시오.
-- 사번, 급여, 부서번호, job_id

select *
from employees
where salary > (select salary 
                from employees
				where employee_id = 112);


-- 사원 테이블에서 최고 급여를 받는 사원 정보를 조회하시오.
-- 사번, 급여, 부서번호, job_id

select  *
from employees
where salary = (select max(salary)
			    from employees);

                
    
-- --------------------------------------------------------
-- 다중행 서브쿼리
-- 2개 이산의 행을 반환
-- 비교 연산자 (IN, NOT IN, EXISTS, NOT EXISTS, ALL, ANY)
-- --------------------------------------------------------

-- 부서번호가 50 부서에 속하는 사원의 입사일자와 같은 모든 사원 정보를 조회하시오.

select hire_date
from employees 
where department_id = 50;

select *
from employees
where hire_date in (select hire_date
				    from employees 
				    where department_id = 50)
order by hire_date asc;
                   
                   
-- 부서 테이블에서 부서정보를 조회하시오.
-- 단, 소속된 사원이 있는 부서만 조회할 것.

select *
from departments
where department_id in (select distinct department_id
						from employees);                   
                   
                   
-- 부서 테이블에서 부서정보를 조회하시오.
-- 단, 소속된 사원이 없는 부서 정보만 조회할 것.

select *
from departments
where department_id not in (select distinct department_id
						    from employees
                            where department_id is not null);    
                            

-- 사원 테이블에서 부서번호가 50번 부서에 소속된 사원들보다 급여를 많이 받는 사원 정보를 조회하시오.
     
select salary
from employees
where department_id = 50
order by salary desc;


select employee_id, salary
from employees
where salary  > ALL  (select salary
				      from employees
				      where department_id = 50)
order by salary asc;

              
-- 사원 테이블에서 부서번호가 50번 부서에 소속된 사원들 중에서 최저급여를 받는 사원보다 
-- 급여를 많이 받는 사원 정보를 조회하시오.

select salary
from employees
where department_id = 50
order by salary asc;
                

select employee_id, salary
from employees
where salary  > any  (select salary
				      from employees
				      where department_id = 50)
order by salary asc;


-- --------------------------------------------
-- Multiple Column Subquery
-- 서브쿼리 결과 여러개의 컬럼인 경우
-- --------------------------------------------

-- 부서별 최고급여를 조회하시오.
-- 부서번호순으로 오름차순 정렬할 것.

select department_id, max(salary) as "max_salary"
from employees
group by department_id
order by department_id asc;


-- 부서별 최고급여를 조회하시오.
-- 부서번호, 사번, 입사입자,급여


select department_id, employee_id, hire_date, salary
from employees
where (department_id, salary) in (select department_id, max(salary) 
							      from employees
								  group by department_id)
order by department_id asc;



-- 부서별 최초 입사한 사원정보를  조회하시오.
-- 사번, 부서번호, 입사일자

select department_id, min(hire_date)
from employees
where department_id is not null
group by department_id;


select department_id, employee_id, hire_date
from employees
where (department_id, hire_date) in (select department_id, min(hire_date)
									 from employees		
                                     where department_id is not null
									 group by department_id)
order by department_id asc, employee_id asc;
                                     
 


-- --------------------------------------------
-- 상호 연관 서브쿼리
-- --------------------------------------------

-- 부서별 평균급여보다 급여를 많이 받는 사원 정보를 조회하시오.

select department_id, employee_id, salary
from employees emp1
where salary > (select avg(salary)
                from employees emp2
				where emp2.department_id = emp1.department_id)
order by department_id asc, employee_id asc;


-- 부서번호 10 ~ 270번 
select *
from departments;

-- 부서 정볼르 조회하시오.
-- 단, 부서에 소속된 사원이 한명도 없는 부서만 출력할 것.


select dept.*
from departments dept
where not exists (select 1
                  from employees emp
				  where emp.department_id = dept.department_id);



-- 부서별 사원수가 5명 이상인 부서에 소속된 사원 정보를 조회하시오.
-- 부서번호, 사번, 이름


select department_id, employee_id
from employees
where department_id in (select department_id
						from employees
						group by department_id
						having count(*) > 5)
 order by department_id asc, employee_id asc;                       


-- --------------------------------------------
-- 스킬라 서브쿼리
-- select 절에 오는 서브쿼리
-- --------------------------------------------

-- 사번이 100인 사원의 정보를 조회하시오. (조인을 이용)
-- 사번, 급여, 부서명 
-- 단, 사원 중 부서에 소속되지 않는 사원이 존재한다. 

select emp.employee_id, emp.salary, dept.department_name
from employees emp
left outer join departments dept
on emp.department_id = dept.department_id
where emp.employee_id = 100;

-- 사번이 100인 사원의 정보를 조회하시오. (스칼라 서브쿼리)
-- 사번, 급여, 부서명


select emp.employee_id, emp.salary,
   (select department_name from departments dept where dept.department_id = emp.department_id) as "부서명"
from employees emp
where emp.employee_id = 178;


select *
from employees
where employee_id = 100;


-- 사번이 100인 사원의 정보를 조회하시오.
-- 사번, 급여, job_title

select employee_id, salary, 
    (select job_title from jobs j where j.job_id = emp.job_id) as "job_title"
from employees emp
where employee_id = 100;


-- --------------------------------------------
-- 인라인뷰
-- FROM절에 오는 서브쿼리
-- --------------------------------------------

-- 부서별 부서번호, 총급여, 부서명을 조회하시오.

select dept.department_id, dept.department_name, emp.max_salary
from departments dept,  (select department_id, max(salary) as max_salary
                         from employees
                         group by department_id) emp
where dept.department_id = emp.department_id;                         
        


select dept.department_id, dept.department_name, emp.max_salary
from departments dept
inner join (select department_id, max(salary) as max_salary
            from employees
            group by department_id) emp
on dept.department_id = emp.department_id;                         
        
        
 -- 부서별 부서번호, 사원수, 부서명을 조회하시오. 
 
 select dept.department_id, dept.department_name, emp.count as "사원수"
 from departments dept, (select department_id, count(*) as "count"
	                     from employees
						 group by department_id) emp
where dept.department_id = emp.department_id;						
 
        
-- 부서별 최고급여를 받는 사원정보를 조회하시오. 
-- 사번, 입사일자, 부서번호,  급여

select emp2.department_id, emp1.employee_id, emp1.hire_date, emp2.max_salary
from employees emp1, (select department_id, max(salary) as max_salary
	                  from employees
                      group by department_id) emp2
where emp1.department_id = emp2.department_id
	and emp1.salary = emp2.max_salary
order by department_id asc, employee_id asc;



-- 50변 부서에 소속된 사원 수를 조회하시오.

select count(*)
from (select *
      from employees
      where department_id = 50) as emp;



-- 사원테이블에서 6번째 행부터 10개의 행을 조회하시오.

select *
from employees
limit 10 offset 5;










        
        
        
