#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	РабочийЦентр = Параметры.РабочийЦентр;
	
	ДатыГрафика = Новый Массив;
	
	СтруктураПоиска = Новый Структура("РабочийЦентр", Параметры.РабочийЦентр);
	ГрафикРаботыРабочегоЦентра = Параметры.ГрафикРаботы.НайтиСтроки(СтруктураПоиска);
	Для каждого СтрокаГрафика Из ГрафикРаботыРабочегоЦентра Цикл
		ДатаГрафика = НачалоДня(СтрокаГрафика.Начало);
		Если ДатыГрафика.Найти(ДатаГрафика) = Неопределено Тогда
			ДатыГрафика.Добавить(ДатаГрафика);
		КонецЕсли; 
	КонецЦикла; 
	
	Для Каждого ДатаГрафика Из ДатыГрафика Цикл
		СтрокаГрафика = ГрафикРаботы.Добавить();
		СтрокаГрафика.ПредставлениеДня = Формат(ДатаГрафика, "ДЛФ=D");
		СтрокаГрафика.ПредставлениеРасписания = ПредставлениеРасписанияДня(ДатаГрафика, ГрафикРаботыРабочегоЦентра);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПредставлениеРасписанияДня(ДатаГрафика, ГрафикРаботыРабочегоЦентра)
	
	ПредставлениеИнтервалов = "";
	Секунд = 0;
	Для Каждого СтрокаРасписания Из ГрафикРаботыРабочегоЦентра Цикл
		Если НачалоДня(СтрокаРасписания.Начало) <> ДатаГрафика Тогда
			Продолжить;
		КонецЕсли;
		ПредставлениеИнтервалов = ПредставлениеИнтервалов 
			+ СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1-%2, ", 
				Формат(СтрокаРасписания.Начало, "ДФ=ЧЧ:мм; ДП="), 
				Формат(СтрокаРасписания.Окончание + 1, "ДФ=ЧЧ:мм; ДП="));
				
		СекундИнтервала = СтрокаРасписания.Окончание - СтрокаРасписания.Начало + 1;
		Секунд = Секунд + СекундИнтервала;
	КонецЦикла;
	СтроковыеФункцииКлиентСервер.УдалитьПоследнийСимволВСтроке(ПредставлениеИнтервалов, 2);
	
	Если Секунд = 0 Тогда
		Возврат НСтр("ru='<расписание не задано>';uk='<розклад не задано>'");
	КонецЕсли;
	
	Часов = Окр(Секунд / 3600, 1);
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1 ч. (%2)';uk='%1 год. (%2)'"), Часов, ПредставлениеИнтервалов);
	
КонецФункции

#КонецОбласти
