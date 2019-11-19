Icarus Verilog 

ТЗ

Синтезировать автомат с одним входом и одним выходом. На вход поступает произвольная последовательность символов 0 и 1. 
Автомат анализирует входные символы группами по три символа.
Выходной сигнал выдается после поступления третьего символа. 
Сигнал на выходе определяется путем логического сложения символов в группе.
Исходные данные: автомат Мили, D- триггер, Элементы И, ИЛИ, НЕ.

Реализовано сложение по модулю 2 (так как не понятно какое требуется, ниже приведены оба решения).

Solution: 
wire dat_s1 = (dat_d1 | dat_d2) & ~(dat_d1 & dat_d2);
wire dat_s2 = (dat_s1 | dat_d3) & ~(dat_s1 & dat_d3);
wire dat_sum_calc = dat_s2;
||
Solution: wire dat_sum_calc = (dat_d1 | dat_d2 | dat_d3);

For start:
iverilog -o compfile top.v
vvp compfile

Fot start gtkwave and hot reloading:
gtkwave out.vcd -a gtkwave.savefile
