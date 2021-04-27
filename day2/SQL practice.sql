-- 급여가 10000이상 15000이하인 사원들의 아이디, 이름, 급여를 조회하기
select employee_id, first_name, last_name, salary
from employees 
where salary >= 10000 and salary <= 150000;

-- 소속부서 아이디가 50번이고, 급여를 3000이상 받는 사원의 아이디, 이름, 급여를 조회하기
select employee_id, first_name, last_name, salary
from employees
where department_id = 50 and salary > 3000;

-- 직종 아이디가 SH-CLEAR이고, 급여를 4000이상 받는 사원의 아이디, 이름, 급여를 조회하기
select employee_id, first_name, last_name, salary
from employees
where job_id = 'SH-CLEAR' and salary >= 4000;

-- 자신의 상사가 101번이거나 102번인 사원의 아이디, 이름, 직종아이디, 상사의 아이디를 조회하기
select employee_id, first_name, last_name, job_id, manager_id
from employees
where manager_id = 101 or manager_id =102;

-- 자신의 상사가 101번이거나 102번인 사원의 아이디, 이름, 직종아이디, 상사의 아이디를 조회하기
select employee_id, first_name, last_name, job_id, manager_id
from employees
where manager_id in (101,102);

-- 소속부서 아이디가 30번이거나 60번이면서 급여를 5000이상 받는 사원의 아이디
-- 이름, 급여, 소속부서 아이디를 조회하기
select employee_id, frist_name, last_name, salary, department_id
from employees
where department_id in (30,60) 
and salary >= 50000;

--괄호필수..괄호가 없으면 검색조건과 맞지 않는 데이터도 조회된다.
select employee_id, first_name, last_name, salary, department_id
from employees
where (dapartment_id = 30 or department_id = 60)    
and salary >= 50000;

-- is null, is not null을 이용해서 컬럼의 값이 null인 것과 null이 아닌것을 구분해서 조회하기
-- departments 테이블에서 등록된 부서 중에서 부서관리자가 지정되지 않은 부서의 아이디,
-- 부서명, 관리자 아이디를 조회하기
select department_id, department_name, manager_id
from departments
where manager_is is null;

-- employees테이블에 등록된 사원들 중에서 커미션을 받는 사원의 아이디, 이름, 급여 커미션 조회하기
select employee_id, first_name, last_name, commission_pct
from employees
where commission_pct is not null;

-- employees테이블에 등록된 사원들 중에서 커미션을 받고, 급여를 10000이상 받는 사원의 아이디,
-- 이름, 급여, 커미션을 조회하기
select employee_id, first_name, last_name, salary, commisstion_pct
from employees
where commisstion_pct is not null 
and salary >= 100000;

-- emplyees테이블에 등록된 사원들 중에서 커미션을 받고, 급여를 10000이상 받는 사원의 아이디,
-- 이름, 급여, 커미션을 조회하기(커미션에 대한 오름차순으로 정렬)
select employee_id, first_name, last_name, salary, commisstion_pct
from employees
where commistion_pct is not null  
and salary >= 100000
order by commission_pct asc;

-- employee테이블에서 사원번호가 110번 이상 120번 이하인 사원아이디, 이름을 조회하기
select employee_id, first_name, last_name
from employees
where employee_id >= 110 and employee_id <= 120;

select employee_id, first_name, last_name
from employees
where employee_id BETWEEN 110 and 120;

-- employees 테이블에서 직종아이디에 CLERK을 포함하고 있는 사원의 아이디, 이름, 직종아이디 조회하기
select employee_id, first_name, last_name, job_id
from employees
where job_id like '%CLERK';

-- employees 테이블에서 직종아이디에 S을 포함하고 있는 사원의 아이디, 이름, 직종아이디 조회하기
select first_name
from employees
where first_name like '%S';

-- employees 테이블에 등록된 사원들 중에서 소속부서 아이디가 30,50,60,80이 아닌 사원의
-- 아이디, 이름, 부서아이디를 조회하기
select employee_id, frist_name, last_name, job_id
from employees
where department_id not in (30,50,60,80)
order by department_id asc;

-- <실습해보기>
-- 모든 부서정보 조회하기
select * 
from departments;
-- 모든 부서소재지정보를 조회하기
select location_id
from departments;
-- 모든 직종정보를 조회하기
select *
from jobs;
-- 직종정보 테이블에서 직종아아디, 최소급여, 최대급여를 조회하기
select job_id, min_salary , max_salary
from jobs;
-- 부서정보 테이블에서 부서아이디, 부서명을 조회하기
select department_id, department_name
from departments;
-- 사원정보 테이블에서 사원아이디, 이름, 해당직종 시작일, 직종아이디, 급여를 조회하기
select employee_id, first_name, last_name, hire_date, job_id, salary
from employees;
-- 사원정보 테이블에서 사원아이디가 100번인 사원의 이름, 전화번호, 이메일, 입사일, 급여를 조회하기
select first_name, last_name, phone_number, email, hire_date, salary
from employees
where employee_id = 100;
-- 사원정보 테이블에서 100번 사원을 상사로 두고 있는 사원들의 이름, 입사일, 직종아이디를 조회하기
select first_name, last_name, hire_date, job_id
from employees
where manager_id = 100;
-- 직종테이블에서 직종 최소급여가 10000 이상인 직종의 아이디, 제목, 최소급여, 최대급여를 조회하기
select job_id, job_title, min_salary, max_salary
from jobs
where min_salary >= 10000;
-- 사원테이블에서 커미션을 받는 사원 중에서 급여를 5000이하 받는 사원의 아이디, 이름, 직종아이디, 급여를 조회하기
select employee_id, first_name, last_name, job_id, salary
from employees
where commission_pct is not null
and salary <= 5000;
-- 사원테이블에서 직종이 'MAN'이나 'MGR'로 끝나는 사원중에서 급여를 10000이하 받는 사원의 아이디,
--이름, 직종아이디, 급여를 조회하기
select employee_id, first_name, last_name, job_id, salary
from employees
where (job_id like '%MAN' or job_id like '%MGR')
and salary <= 10000;
-- 사원정보테이블에서 커미션을 받는 사원중에서 147번 사원을 상사로 두고 있으면서, 급여를 10000이상 받는 
-- 사원의 아이디, 사원이름, 급여, 커미션을 조회하기
select employee_id, first_name, last_name, salary, commission_pct
from employees
where commission_pct is not null 
and manager_id = 147 and salary >= 10000;
-- 사원정보테이블에서 101번과 102번이 상사로 정해진 사원들의 아이디, 이름, 상사아이디를 조회하기
select employee_id, first_name, last_name, manager_id
from employees
where manager_id in (101, 102)
order by manager_id asc;
-- 사원정보테이블에서 소속부서가 결정되지 않은 사원의 아이디, 이름, 직종아이디를 조회하기
select employee_id, first_name, last_name, job_id
from employees
where department_id is null;
-- 사원정보테이블에서 60번 부서에 소속된 사원들의 아이디, 이름, 월급, 연봉을 조회하기
-- (salary는 월급이다. 연봉은 별칭을 부과한다.)
select employee_id, first_name, last_name, salary, salary*12 annal_salary
from employees
where department_id = 60;

-- 문자함수 연습하기
-- lower(컬럼명 혹은 표현식) - 소문자로 변환
-- upper(컬럼명 혹은 표현식) - 대문자로 변환
-- substr(컬럼명 혹은 표현식, 시작위치, 갯수) - 시작위치에서 갯수만큼 잘라서 반환
-- length(컬럼명 혹은 표현식) - 문자열의 길이 반환
-- instr(컬럼명 혹은 표현식, '문자') - 지정된 문자의 위치를 반환(인덱스는 1부터 시작)
-- instr(컬럼명 혹은 표현식, '문자', 시작위치, n번째) - 지정된 시작위치부터 문자를 검색했을 때 n번째로 등장하는 위치를 반환
-- lpad(컬럼명 혹은 표현식, 길이, '문자') - 지정된 길이보다 짧으면 부족한 길이만큼 지정된 문자를 왼쪽에 채운다.
-- rpad(컬럼명 혹은 표현식, 길이, '문자') - 지정된 길이보다 짧으면 부족한 길이만큼 지정된 문자를 오른쪽에 채운다.
-- trim(컬럼명 혹은 표현식) - 불필요한 좌우 공백을 제거한다.
-- replace(컬럼 혹은 표현식, '찾는문자', '대체할 문자') - 문자를 찾아서 지정된 문자로 대체한다.
select lower('Hello world'), 
       upper('Hello World'), 
       substr('Hello World',3),
       substr('Hello World',1,1),
       substr('Hello World',3,4),
       length('Hello World'),   -- 11글자
       lengthb('Hello World'),  -- 11byte
       length('안녕하세요'),      -- 5글자
       lengthb('안녕하세요'),     -- 15byte
       instr('010-1111-1111', '-'),  -- 4   
       instr('02)1234-5678', ')'),   -- 3
       instr('700)-1234-5677', ')'), -- 4
       instr('010-1111-1111', '-'),
       instr('010-1111-1111', '-'),
       lpad('100', 10, '0'),         -- 0000000100
       lpad('12345', 10, '0'),       -- 0000012345
       replace('hello', 'l', '*')    -- he**o
from dual;      --dual 1행1열짜리 테이블, 간단하게 확인할때..

-- employees 테이블에서 이름에 'tay'가 포함되는 사원을 조회하기
select first_name
from employees
where lower(first_name) like '%tay%';

-- employees 테이블에서 'MAN' 이나 'MGR'로 끝나는 직종을 가진 사원의 이름 직종아이디 조회하기
select first_name, job_id
from employees
where substr(job_id, 4) in ('MAN', 'MGR'); -- substr('SA_MAN', 4) -> 'MAN'

-- employees 테이블에서 사원아이디, 이름, 휴대폰번호의 1번째로 나오는 '.' 이후로 2번째나오는 '.' + 1 이후
-- 를 뽑아내서 별칭을 붙여라
-- (전화번호의 2번째 구분점 부터 조회)
-- select employee_id, first_name, phone_number, instr(phone_number, '.', 5) -- 5번째 이후부터 나오는 '.'
select employee_id, first_name, phone_number, substr(phone_number, instr(phone_number, '.', 1, 2) + 1) short_phone_number -- '.'이 나온 1번째 이후로 나오는 2번째 '.'
from employees;

-- employees 테이블에서 사원아이디, 이름, 이메일을 조회하기
-- (단, 이메일의 첫2글자는 **로 바꾸기)
select employee_id, first_name, email,
    lower(replace(email, substr(email,1,2), '**')) secret_email
from employees;

select replace('aaabbaabb', substr('aaabbaabb', 3, 2), '**'),
    replace(substr('aaabbaabb',1,4),substr('aaabbaabb', 3, 2), '**') || substr('aaabbaabb',5) 
from dual;    