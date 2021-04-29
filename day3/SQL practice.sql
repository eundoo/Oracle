-- 숫자함수
select 
	round(1.4), -- 1 
	trunc(1.4), -- 1
	ceil(1.4),  -- 2, 지정된 숫자보다 같거나 큰 정수 중에서 가장 작은 정수 반환
	floor(1.4)  -- 1, 지정된 숫자보다 같거나 작은 정수 중에서 가장 큰 정수 반환
from dual;

select 
	round(1.8), -- 2 
	trunc(1.8), -- 1
	ceil(1.8),  -- 2
	floor(1.8)  -- 1
from dual;

select 
	round(1234.56789, 4), --  1234.5679, 소수점이하 5번째 자리에서 반올림
	round(1234.56789, 3), --  1234.568   소수점이하 4번째 자리에서 반올림
	round(1234.56789, 2), --  1234.57    소수점이하 3번째 자리에서 반올림
	round(1234.56789, 1), --  1234.6     소수점이하 2번째 자리에서 반올림
	round(1234.56789, 0), --  1235       소수점이하 1번째 자리에서 반올림
	round(1234.56789, -1), -- 1230       일의 자리에서 반올림
	round(1234.56789, -2), -- 1200       십의 자리에서 반올림
	round(1234.56789, -3)  -- 1000       백의 자리에서 반올림
from dual;

select 
    trunc(1234.56789, 4), --  1234.5678, 소수점이하 4번째 자리까지 남기고 버림
	trunc(1234.56789, 3), --  1234.567   소수점이하 3번째 자리까지 남기고 버림
	trunc(1234.56789, 2), --  1234.56    소수점이하 2번째 자리까지 남기고 버림
	trunc(1234.56789, 1), --  1234.5     소수점이하 1번째 자리까지 남기고 버림
	trunc(1234.56789, 0), --  1234       소수점부분 전부 버림
	trunc(1234.56789, -1), -- 1230       일의 자리 버림
	trunc(1234.56789, -2), -- 1200       십의 자리 버림
	trunc(1234.56789, -3)  -- 1000       백의 자리 버림
from dual;

-- 날짜 관련 함수
-- sysdate : 시스템의 현재 날짜 시간정보 반환
select sysdate from dual; -- 시스템의 현재 날짜, 시간정보를 반환한다.

-- months_between(date1, date2) : 두 날짜간의 개월 수 반환
select employee_id, first_name, hire_date, trunc(months_between(sysdate, hire_date))
from employees;

-- 날짜 연산
-- date + 숫자 -> 날짜 : date에서 숫자만큼 경과된 날짜, 숫자는 day 수
-- date - 숫자 -> 날짜: date에서 숫자만큼 이전 날짜
-- date - date -> 숫자: 두 날짜 간의 day 수

select sysdate + 5, sysdate - 5 
from dual;

-- 60번 부서에 소속된 사원들이 해당 직종의 근무일수 계산
select employee_id, first_name, hire_date, trunc(sysdate - hire_date)
from employees
where department_id = 60;

-- next_day(요일) : 지정된 날짜를 기준으로 가장 최근 요일의 날짜를 반환
select sysdate, next_day(sysdate, '월')
from dual;

-- last_day(날짜) : 지정된 달의 마지막 일자를 반환

-- 묵시적 형변환
select employee_id, salary 
from employees 
where salary >= 15000;

-- 묵시적 형변환
select employee_id, salary 
from employees 
where salary >= '15000';	-- 문자 '15000' -> 숫자 15000으로 자동 변환

select employee_id, first_name, hire_date
from employees
where hire_date > '2007/01/01'; -- 문자 '2007/01/01' -> 날짜로 자동 형변환


select employee_id, first_name, hire_date
from employees
where hire_date > '2007-01-01'; -- 문자 '2007-01-01' -> 날짜로 자동 형변환

select employee_id, first_name, hire_date
from employees
where hire_date > '20070101'; -- 문자 '20070101' -> 날짜로 자동 형변환

select employee_id, first_name, hire_date
from employees
where hire_date > '2007.01.01'; -- 문자 '2007.01.01' -> 날짜로 자동 형변환

-- 명시적 형변환
-- 숫자 -> 형식화된 문자
select employee_id, first_name, 
	salary, to_char(salary, '999,999'),
	commission_pct, to_char(commission_pct, '0.99')
from employees
where commission_pct is not null;

-- 날짜 -> 형식화된 문자열
select employee_id, first_name, hire_date, 
	to_char(hire_date, 'yyyy'),
	to_char(hire_date, 'mm'),
	to_char(hire_date, 'dd'),
	to_char(hire_date, 'yyyy/mm/dd'),
	to_char(hire_date, 'yyyy-mm-dd'),
	to_char(hire_date, 'yyyy"년" mm"월" dd"일" day'),
	to_char(hire_date, 'hh:mi:ss'),
	to_char(hire_date, 'hh"시" mi"분" ss"초"')
from employees;

-- 문자 -> 숫자
-- 형식화된 문자 -> 숫자
select '100' + '100' from dual; -- 묵시적 형변환
select to_number('1,000', '9,999') + to_number('1,000', '9,999') from dual; -- 명시적 형변환

-- 문자 -> 날짜
-- 형식화된 문자 -> 날짜
select sysdate - to_date('2020/12/25', 'yyyy/mm/dd') from dual; -- 명시적 형변환

-- 기념일 계산하기
select to_date('2020/01/01') + 1000 from dual;

-- nvl 함수
-- nvl(null값이 예상되는 컬럼 혹은 표현식, 대체할 값)
select nvl(1000, 0),
		nvl(null, 0)
from dual;

-- null인 값과의 사칙연산결과는 언제나 null이다
select 100 + null, 100 - null, 100*null, 100/null
from dual;

-- employees 테이블에서 사원아이디, 이름, 급여, 커미션이 적용된 급여를 조회하기
select employee_id, first_name, salary, salary + salary*nvl(commission_pct, 0)
from employees;

-- nvl2(컬럼 혹은 값, null아닐 때 값, null일 때 값)
-- 2번째, 3번째 값의 타입이 동일해야 한다.
-- employees 테이블에서 사원아이디, 이름, 급혀, 커미션(급여에 대한 실제 커미션 금액)을 조회하기
select employee_id, first_name, salary,
        nvl2(commission_pct, salary*commission_pct, 0) commission_1,
        salary*nvl(commission_pct, 0) commission_2
from employees;

-- decode(컬럼 혹은 표현식, 값1, 표현식, null)
-- 첫번째 파라미터값이 값1과 일치하면 표현식의 결과가 반환되고,
--                       일지하지 않으면 null이 반환된다.(null은 생략가능)

-- decode(컬럼 혹은 표현식, 값1, 표현식1, 표현식2)
-- 첫번째 파라미터값이 값1과 일치하면 표현식1의 결과가 반환되고,
--                       일치하지 않으면 표현식2의 결과가 반환된다.

-- decode(컬럼 혹은 표현식, 값1, 표현식1,
--                       값2, 표현식2,
--                       값3, 표현식3,
--                       표현식4)
-- 첫번째 파라미터의 값이 값1과 일치하면 표현식1의 결과가 반환되고,
--                    값2와 일치하면 표현식2의 결과가 반환되고,
--                    값3과 일치하면 표현식3의 결과가 반환되고,
--                    값1/값2/값3모두와 일치하지 않으면 표현식4의 결과가 반환된다.

-- employees에서 소속부서번호가 10,20,30,에 해당하는 사원들의 
-- 사원아이디, 이름, 부서번호, 급여, 보너스를 조회하기
-- (부서번호가 10인 부서에 소속된 사원들은 급여의 20%를 보너스로 지급하도록 조회하기)
select employee_id, first_name, department_id, salary,
        decode(department_id, 10, salary*0.2) bonus
from employees
where department_id in (10,20,30);

-- employees에서 소속부서번호가 10,20,30,에 해당하는 사원들의 
-- 사원아이디, 이름, 부서번호, 급여, 보너스를 조회하기
-- (10번 부서는 급여의 10%, 20번 부서는 급여의 20%, 30번 부서는 급여의 30%를 보너스로 지급)
select employee_id, fisrt_name, department_id, salary,
        decode(department_id, 10, salary*0.1,
                              20, salary*0.2,
                              30, salary*0.3) bonus
from employees
where department_id in (10,20,30);

-- employees 테이블에서 직종아이디에 Clerk가 포함되어있는 일반 사원들인 경우
-- 전체 평균급여의 50%를 보너스로 지급하고, 그 외는 전체 평균급여의 30%를 보너스로 지급
-- 사원아이디, 이름, 직종, 보너스를 출력하기
select employee_id, first_name, job_id,
        decode(substr(job_id, 4),'CLERK', (select trunc(avg(salary)/2) from employees),
                                          (select trunc(avg(salary)*0.3) from employees)) bonus
from employees;

-- case 문
-- if문과 같은 역학을 수행한다.
-- decode는 equal 비교만 가능한데 비해서, case문은 >, >=, <, <= 등의 비교도 가능하다.

-- case
--      when 조건식1 then 표현식1
--      when 조건식2 then 표현식2
--      when 조건식3 then 표현식3
--                  else 표현식3
-- end
-- employees테이블에서 급여를 20000달러 이상 받는 경우 급여의 10%를 보너스로 지급하고,
--                         10000달러 이상 받는 경우 급여의 30%를 보너스로 지급하고,
--                          5000달러 이상 받는 경우 급여의 50%를 보너스로 지급하고,
--                                        그 외는 급여의 75%를 보너스로 지급한다.
-- 사원아이디, 이름, 급여, 보너스를 조회하기(보너스는 10의 자링레서 반올림한다.) 
select employee_id, first_name, salary,
    round(case 
            when salary >= 20000 then salary*0.1
            when salary >= 10000 then salary*0.3
            when salary >= 5000 then salary*0.5
            else salary*0.75
          end, -2) as bonus
from employees;

-- employees 테이블에 저장된 사원들의 급여를 기준으로 등급을 조회하려고 한다.
-- 급여가 20000이상인 경우 A, 10000이상인 경우 B, 5000이상인 경우 C,
--       2500이상인 경우 D, 그 외는 E 등급으로 판정한다.
-- 사원아이디, 이름, 급여, 급여등급을 조회하기 

select employee_id, first_name, salary,

    case
        when salary >= 20000 then 'A'
        when salary >= 10000 then 'B'
        when salary >= 5000 then 'C'
        when salary >= 2500 then 'D'
        else 'E'
    end salary_grade
from employees;


-- 실습해보기
-- employees 테이블에서 관리자(상사)의 사원아이디를 중복없이 조회하기
select DISTINCT manager_id
from employees
where manager_id is not null;
-- employees 테이블에 등록된 사원들이 소속된 부서아이디를 중복없이 조회하기
-- (소속부서가 없는 사원은 제외시킨다.)
select DISTINCT department_id
from employees
where department_id is not null;
-- employees 테이블에서 사원아이디, 이름, 이메일을 조회하기(이메일은 소문자로 표시)
select employee_id, first_name, lower(email)
from employees;
-- employees 테이블에서 이름이 A로 시작하는 사원의 아이디, 이름을 조회하기
select employee_id, first_name
from employees
where first_name like 'A%';

select employee_id, first_name
from employees
where substr(first_name, 1, 1) = 'A';
-- employees 테이블에서 모든 사원들의 아이디, 이름, 급여, 연간 총 수입을 조회하기
-- 연간 총수입은 급여*12 + (급여*12*commission_pct)다.
select employee_id, first_name, salary, salary*12 + (salary*12*commission_pct) bonus
from employees;
-- employees 테이블에서 80번 부서에서 근무중인 사원들의 사원아이디, 이름, 급여, 세금을 조회하기
-- 14000이상 45%, 10000이상 42%, 7500이상 35%, 5000이상 25%, 2000이상 9%, 그외는 0%다.
select employee_id, first_name, salary
    case
        when salary >= 14000 then salary*0.45
        when salary >= 10000 then salary*0.42
        when salary >= 7500 then salary*0.35
        when salary >= 5000 then salary*0.25
        when salary >= 2000 then salary*0.09
        else 0
    end as tax
    from employees
    where department_id = 80;
-- employees 테이블에서 50번 부서에서 근무중이 사원들의 급여를 15% 인상했을 때,
-- 사원아이디, 이름, 인상전 급여, 인상된 급여, 인상된 급여와 인상전 급여의 차이를 조회하기
select employee_id, first_name, salary, salary + salary*0.15, salary*0.15 difference
from employees
where department_id = 50;
-- employees 테이블에서 사원의 이름이 'A', 'J' 또는 'M'으로 시작하는 사원의 아이디, 이름을 조회하기
select employee_id, first_name
from employees
where first_name like 'A%' or first_name like 'J%' or first_name like 'B%';

select employee_id, first_name
from employees
where substr(first_name, 1, 1) in ('A', 'J', 'M');
-- employees 테이블에서 근무를 시작한 날로부터 오늘까지 근무한 개월수를 계산해서 조회하기
-- 사원아이디, 이름, 입사일, 근무한 개월수(개월수는 정수로 반올림한다.)만 조회한다.
select employee_id, first_name, hire_date, trunc(months_between(sysdate, hire_date)) workingmonths
from employees;
-- employees 테이블에서 사원들의 급여를 *의 갯수로 표시하려고 한다.
-- *하나가 1000달러를 나타낸다고 했을 때, 사원의 아이디, 이름, 급여, *을 표시하기
-- 100 홍길동 3400  ***
-- 101 김유신 15000 ***************
-- 102 강감찬 7300  *******
select employee_id, first_name, salary lpad('*',trunc(salary/1000),'*')
from employees;