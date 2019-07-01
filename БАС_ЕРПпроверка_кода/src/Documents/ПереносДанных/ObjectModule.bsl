#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	// Подготовка к регистрации перерасчетов
	ДанныеДляРегистрацииПерерасчетов = Новый МенеджерВременныхТаблиц;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = ДанныеДляРегистрацииПерерасчетов;
	
	Запрос.Текст =
		"ВЫБРАТЬ
		|	NULL КАК Организация,
		|	NULL КАК Сотрудник,
		|	NULL КАК ПериодДействия,
		|	NULL КАК ДокументОснование
		|ПОМЕСТИТЬ ВТДанныеДокументов
		|ГДЕ
		|	ЛОЖЬ";
		
	Запрос.Выполнить();
	
	ПерерасчетЗарплаты.СборДанныхДляРегистрацииПерерасчетов(Ссылка, ДанныеДляРегистрацииПерерасчетов, Организация, Истина);
	ДополнительныеСвойства.Вставить("ДанныеДляРегистрацииПерерасчетов", ДанныеДляРегистрацииПерерасчетов);
	
	УправлениеШтатнымРасписанием.ПроверитьВозможностьИзменитьШтатноеРасписание(
		Движения.ИсторияИспользованияШтатногоРасписания.ВыгрузитьКолонку("ПозицияШтатногоРасписания"),
		ПериодРегистрации,
		Ссылка,
		РежимЗаписи,
		Отказ,
		"МесяцНачисленияСтрокой");

	Если Не ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.Свойство("ДанныеДляРегистрацииПерерасчетов") Тогда
		ПерерасчетЗарплаты.РегистрацияПерерасчетов(Движения, ДополнительныеСвойства.ДанныеДляРегистрацииПерерасчетов, Организация);
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл
		
		Движение.Прочитать();
		Движение.УстановитьАктивность(ФлагАктивности);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли