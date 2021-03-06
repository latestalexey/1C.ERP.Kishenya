#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписью(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Регистратор = Отбор.Регистратор.Значение;
	
	Для каждого Запись Из ЭтотОбъект Цикл
		Запись.ДокументОснование = Регистратор;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТекущийНабор", ЭтотОбъект.Выгрузить());
	Запрос.УстановитьПараметр("Регистратор", Регистратор);
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Сотрудник
		|ПОМЕСТИТЬ ВТДанныеНабора
		|ИЗ
		|	&ТекущийНабор КАК ПериодыДействияДоговоровГражданскоПравовогоХарактера
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Сотрудник
		|ПОМЕСТИТЬ ВТВсеСотрудникиРегистратора
		|ИЗ
		|	РегистрСведений.ПериодыДействияДоговоровГражданскоПравовогоХарактера КАК ПериодыДействияДоговоровГражданскоПравовогоХарактера
		|ГДЕ
		|	ПериодыДействияДоговоровГражданскоПравовогоХарактера.Регистратор = &Регистратор
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДанныеНабора.Сотрудник
		|ИЗ
		|	ВТДанныеНабора КАК ДанныеНабора
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВсеСотрудникиРегистратора.Сотрудник
		|ИЗ
		|	ВТВсеСотрудникиРегистратора КАК ВсеСотрудникиРегистратора";
		
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ДополнительныеСвойства.Вставить("ОбновляемыеСотрудники", РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Сотрудник"));
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)

	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ОбновляемыеСотрудники") Тогда
		КадровыйУчетРасширенный.ОбновитьТекущиеКадровыеДанныеПоДоговорамГПХ(ДополнительныеСвойства.ОбновляемыеСотрудники);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
