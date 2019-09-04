-- 절대값
select abs(2), abs(-2);

-- mod 연산(나머지 값)
select mod(7, 2), mod(15, 4);

-- round(x) : x에 가장 근접한 정수 반환
select round(1.298), round(1.5111);

-- round(x, d) : d자리에 가장 근접한 실수 반환
select round(1.298, 1), round(1.5111, 0);

-- 제곱승
select pow(2, 10), power(10, 5);

-- sign(x) : x가 음수이면 -1, 양수이면 1, 0이면 0
select sign(-2), sign(2), sign(0);

-- 가장 큰 값, 가장 작은 값
select greatest(10, 2, 4, 9),
	least(10, 2, 4, 9),
    greatest('Abc', 'Abc1', 'ABcd');