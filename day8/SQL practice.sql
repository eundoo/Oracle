-- subquery

----------------------------------------단일행 서브쿼리---------------------------------------------------
-- 전체 사원의 평균급여보다 급여를 적게 받는 사원들의 사원아이디, 이름, 급여를 조회하기
-- 조건식에서 사원의 급여와 비교되는 전체사원의 평균급여는 select문의 실행결과로 획득되는 값이다.
-- 따라서, where절에 사원들의 전체 평균을 조회하는 select문(서브쿼리)이 필요하다.
select employee_id, first_name, salary
from employees
where salary < (select avg(salary) -- 원래는 이 부분이 그림3 처럼 적었어야 됐다.
                from employees);
                -- 서브쿼리가 실행되야만 조건식이 이뤄질 수 있다.
                
-- 100번 사원과 같은 부서에서 근무하는 사원들의 사원아이디, 이름을 조회하기
-- 1. 100번 사원이 소속되어 있는 부서아이디
select department_id
from employees 
where employee_id = 100;

-- 2. 90번 부서에서 근무하고 있는 사원들의 사원아이디, 이름 조회하기
select employee_id, first_name
from employees
where department_id = 90;

-- 3. 100번 사원과 같은 부서에서 근무하는 사원들의 사원아이디, 이름을 조회하기
select employee_id, first_name
from employees
where department_id = (select department_id
                        from employees 
                        where employee_id = 100);   --서브쿼리의 값이 90이 됨
                        
----------------------------------------다중행 서브쿼리---------------------------------------------------
-- 부서별 평균급여를 조회했을 때 평균급여가 5000달러 이상인 부서에 근무중인 사원들 조회하기
-- 1. 부서별 평균급여를 조회했을 때 평균급여가 5000달러 이상인 부서
select department_id --10,30,50번 부서의 평균급여가 5000달러 이하
from employees
where department_id is not null
group by department_id
having avg(salary) <= 5000;
-- 2. 5000달러 이하 부서에 근무중인 사원들 조회하기
select employee_id, first_name, department_id
from employees
where department_id in (10,30,50);

-- 3. 부서별 평균급여를 조회했을 때 평균급여가 5000달러 이하인 부서에 근무중인 사원들 조회하기
select employee_id, first_name, department_id
from employees
where department_id in (select department_id 
                        from employees
                        where department_id is not null
                        group by department_id
                        having avg(salary) <= 5000);     
-- 다중행 사진4참조

-- 직종 최소급여가 10000달러 이상인 직종에 종사중인 사원들의 아이디, 이름, 직종아이디를 조회하기
-- 1. 직종 최소급여가 10000달러 이상인 직종
select job_id
from jobs
where min_salary >= 10000;
-- 2. 직종 최소급여가 10000달러 이상인 직종에 종사중인 사원
select employee_id, first_name, job_id, salary
from employees
where job_id in('AD_PRES', 'AD_VP', 'SA_MAN');
-- 3. 직종 최소급여가 10000달러 이상인 직종에 종사중인 사원들의 아이디, 이름, 직종아이디 조회하기
select employee_id, first_name, job_id, salary
from employees
where job_id in (select job_id
                 from jobs
                 where min_salary >= 10000);
-- 서브쿼리로 해결되는 문제를 조인으로 해결하기 (아무거나 조인으로 바꿀 수 있는건 아니고 계산이 들어가 있지 않은 것은 바꿀 수 있다.)
select E.employee_id, E.first_name, E.job_id, E.salary
from jobs J, employees E
where J_min_salary >= 10000
and J_job = E.job_id;

-- 60번 부서에 소속된 사원들 중에서 60번 부서에 소속된 직원의 급여보다 급여를 많이 받는
-- 사원의 아이디, 이름, 급여를 조회하기
-- 1. 60번 부서에 소속된 사원들의 급여 조회
select salary --9000,6000,4800,4200
from employees
where department_id = 60;

-- 2. 60번 부서에 소속된 직원의 모든 급여보다 급여를 많이 받는 50번 부서의 사원조회
select employee_id, first_name, salary
from employees 
where department_id = 50
and salary >all(9000,6000,4800,4200); --and salary > 9000
-- 2. 60번 부서에 소속된 직원의 급여 중 아무거나 하나보다 급여를 많이 받는 50번 부서의 사원조회
select employee_id, first_name, salary
from employees 
where department_id = 50
and salary >any(9000,6000,4800,4200); --and salary > 4200
-- 3. 50번 부서에 소속된 사원중엥서 60번 부서에 소속된 직원의 급여보다 급여를 맣이 받는 
-- 사원의 아이디, 이름, 급여를 조회하기
select employee-id, first_name, salary
from employees 
where department_id = 50
and salary > all (select salary
                  from employees
                  where department_id = 60);
--> 'all'은 '>max()'로 대체할 수 있다.
select employee-id, first_name, salary
from employees 
where department_id = 50
and salary > all (select max(salary)
                  from employees
                  where department_id = 60);
                  
----------------------------------------다중열 서브쿼리---------------------------------------------------
-- 부서별 최고 급여를 받는 사원의 아이디, 이름, 급여, 부서아이디를 조회하기
-- 1. 부서별 최고 급여를 조회하기
select department_id, max(salary)
from employees
where department_id is not null
group by department_id;
-- 2. 부서별 최고 급여를 받는 사원을 조회하기
select employee_id, first_name, salary, department_id
from employees
where (department_id, salary) in (select department_id, max(salary)
                                  from employees
                                  where department_id is not null
                                  group by department_id);
                                  
----------------------------------------having절 서브쿼리---------------------------------------------------
-- 부서별 사원수를 조회했을 때 가장 인원수가 많은 부서의 아이디와 인원수를 조회하기
-- 1.부서별 사원수를 조회하기
select department_id, count(*)
from employees
where department_id is not null
group by department_id;
-- 2. 가장 많은 인원수 조회하기
select max(count(*)) -- 45 --max는 값이 하나밖에 안나오니까 여기에 department_id못넣는다.
from employees
where department_id is not null
group by department_id;
-- 3. 가장 많은 인원수를 보유하고 있는 부서
select department_id, count(*)
from employees
where department_id is not null
group by department_id
having count(*) = 45;
-- 4. 부서별 사원수를 조회했을 때 가장 인원수가 많은 부서의 아이디와 인원수를 조회하기
select department_id, count(*)
from employees
where department_id is not null
group by department_id
having count(*) = (select max(count(*))
                   from employees
                   where department_id is not null
                   group by department_id);
                   
                   
                   
-- (서브쿼리의 실행결과가 한개) 단일행 서브쿼리 연습 -----------------------------------------------------------------
-- Neena와 같은 해에 입사한 사원들의 아이디, 이름, 입사일 조회하기
select employee_id, first_name, hire_date
from employees 
where to_char(hire_date, 'yyyy') = (select to_char(hire_date, 'yyyy')
                                    from employees 
                                    where first_name = 'Neena');
                                    
-- Neena와 같은 해에 입사한 사원중에서 전체 사원의 평균급여보다 급여를 많이 받는
-- 사원의 아이디, 이름, 입사일, 급여를 조회하기
select employee_id, first_name, hire_date, salary
from employees 
where to_char(hire_date, 'yyyy') = (select to_char(hire_date, 'yyyy')
                                    from employees 
                                    where first_name = 'Neena')
and salary > (select avg(salary)
              from employees);
              
-- Neena의 상사가 소속되어 있는 부서와 같은 부서에서 근무하는 사원의 아이디,
-- 이름, 직종, 부서아이디를 조회하기
select employee_id, first_name, job_id, department_id
from employees 
where department_id = (select department_id -- 니나의 상사가 소속된 부서의 아이디
                       from employees 
                       where employee_id = (select manager_id -- 니나의 상사
                                            from employees
                                            where first_name = 'Neena'));
                                            
-- 60번 부서에 소속된 사원들의 급여를 인상시키기
-- (인상액은 전체 사원 평균급여의 10%, 소수점이하는 반올림한다.)
update employees 
set 
   salary = salary + (select round(avg(salary)*0.1) -- 원래 자신의 salary에서 + 평균급여의 10%인상(만큼을 더한것)
                      from employees)
where department_id = 60;




-- (서브쿼리의 실행결과가 두개 이상) 다중행 서브쿼리 연습하기 ----------------------------------------------------------
-- 100 상사에게 보고하는 직원이 자신의 상사인 사원들의 아이디, 이름, 상사의 아이디를 조회하기
select employee_id, first_name, manager_id --100번의 상사에게 보고하는 직원의 부하
from employees 
where manager_id in (select employee_id --100번의 상사에게 보고하는직원  
                     from employees 
                     where manager_id = 100); --그림6 참조
                     
-- 직종이 변경된 적이 있는 직원의 아이디, 이름, 소속부서아이디를 조회하기
select employee_id, first_name, department_id
from employees
where employee_id in(select distinct employee_id
                       from job_history);
                       
-- 'Seattle'에서 일하고 있는 사원들의 사원아이디, 이름, 부서아이디를 조회하기
select employee_id, first-name, department_id
from employees
where department_id in (select department_id
                        from departments
                        where location_id in (select location_id
                                              from locations
                                              where city = 'Seatle'));
                                              -- 값이 한개 나오든 여러개나오든 in 적어도 되니까 in으로 통일해도 좋다.

-- 'Steven'의 급여보다 많은 급여를 받는 사원들의 아이디, 이름, 급여를 조회하기
-- 크다, 작다와 같은 비교연산자를 사용할 때는 서브쿼리의 연산결과가 반드시 단일행이어야 한다.
select employee_id, firlst_name, salary
from employees
where salary > (select salary
                from employees
                where first_name = 'Steven'); -- Steven의 급여구하기 -- 이대로 실행하면 오류임 왜냐면 Steven이 2명이니까 ...
                                              -- 그럴땐 사원아이디를 찾는다던지 (100번스티븐인지 102번스티븐인지...)
                                              -- all 이나 any는 우리 의도가 아님....
                                              -- 그래서 결국에 '>' , '<' 쓸때만 단일행이냐 다중행이냐 따지고 나머지는 다 in을 써도 된다.
