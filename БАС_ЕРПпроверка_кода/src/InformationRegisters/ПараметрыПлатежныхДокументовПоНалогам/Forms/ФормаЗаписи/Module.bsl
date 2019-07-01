
&НаКлиенте
Процедура ГруппаУчетаУдержанийПриИзменении(Элемент)
	УстановитьВидимостьИОчистить();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьИОчистить()
	
	Если Запись.ГруппаУчетаУдержаний = ПредопределенноеЗначение("Справочник.ГруппыУчетаНачисленийИУдержаний.ЕСВ") Тогда
		Элементы.КодДохода.Видимость = Ложь;
		Если ЗначениеЗаполнено(Запись.КодДохода) Тогда
			Запись.КодДохода = "";
		КонецЕсли;
		Элементы.Налог.Видимость = Истина;
	Иначе
		Элементы.Налог.Видимость = Ложь;
		Если ЗначениеЗаполнено(Запись.Налог) Тогда
			Запись.Налог = "";
		КонецЕсли;
		Элементы.КодДохода.Видимость = Истина;
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимостьИОчистить();
КонецПроцедуры
