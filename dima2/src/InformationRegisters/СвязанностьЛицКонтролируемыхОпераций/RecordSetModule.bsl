
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого Строка Из ЭтотОбъект Цикл
		Для Сч = 1 По 4 Цикл
			Если НЕ ЗначениеЗаполнено(Строка["КодСвязанностиЛиц" + Сч])
			   И НЕ Строка["КодСвязанностиЛиц" + Сч] = "   " Тогда
			   Строка["КодСвязанностиЛиц" + Сч] = "   "; 
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла;
	
КонецПроцедуры
