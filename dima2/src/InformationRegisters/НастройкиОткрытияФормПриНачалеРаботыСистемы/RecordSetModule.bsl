#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	НастройкиОткрытияФорм.Пользователь,
	|	НастройкиОткрытияФорм.ОткрываемаяФорма
	|ПОМЕСТИТЬ НастройкиОткрытияФорм
	|ИЗ
	|	&НастройкиОткрытияФорм КАК НастройкиОткрытияФорм
	|ГДЕ
	|	НастройкиОткрытияФорм.ОткрыватьПоУмолчанию
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВложенныйЗапрос.ОткрываемаяФорма) КАК КоличествоФорм,
	|	ВложенныйЗапрос.Пользователь КАК Пользователь
	|ИЗ
	|	(ВЫБРАТЬ
	|		НастройкиОткрытияФорм.Пользователь КАК Пользователь,
	|		НастройкиОткрытияФорм.ОткрываемаяФорма КАК ОткрываемаяФорма
	|	ИЗ
	|		НастройкиОткрытияФорм КАК НастройкиОткрытияФорм
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		НастройкиОткрытияФормПриНачалеРаботыСистемы.Пользователь,
	|		НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрываемаяФорма
	|	ИЗ
	|		РегистрСведений.НастройкиОткрытияФормПриНачалеРаботыСистемы КАК НастройкиОткрытияФормПриНачалеРаботыСистемы
	|	ГДЕ
	|		НастройкиОткрытияФормПриНачалеРаботыСистемы.ОткрыватьПоУмолчанию) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Пользователь
	|
	|ИМЕЮЩИЕ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВложенныйЗапрос.ОткрываемаяФорма) > 1";
	
	Запрос.УстановитьПараметр("НастройкиОткрытияФорм", ЭтотОбъект.Выгрузить());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		ТекстСообщения = НСтр("ru='Пользователю ""%Пользователь%"" назначено более одной формы, открываемой по умолчанию.';uk='Користувачу ""%Пользователь%"" призначено більше однієї форми, що відкривається за замовчуванням.'");
		
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Пользователь%", Выборка.Пользователь); 
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
