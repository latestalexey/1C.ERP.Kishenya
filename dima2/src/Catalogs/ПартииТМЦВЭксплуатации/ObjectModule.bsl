
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДатаЗавершенияЭксплуатации = КонецМесяца(ДобавитьМесяц(Дата, СрокЭксплуатации));
	
	СформироватьНаименование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФукнции

Процедура СформироватьНаименование()
	
	Шаблон = НСтр("ru='Выдано %Дата% на %СрокЭксплуатации% мес. (до %ДатаЗавершенияЭксплуатации%) %НалоговоеНазначение%';uk='Видано %Дата% на %СрокЭксплуатации% міс. (до %ДатаЗавершенияЭксплуатации%) %НалоговоеНазначение%'");
	
	Шаблон = СтрЗаменить(Шаблон, "%Дата%", Формат(Дата, "ДЛФ=D"));
	Шаблон = СтрЗаменить(Шаблон, "%СрокЭксплуатации%", СрокЭксплуатации);
	Шаблон = СтрЗаменить(Шаблон, "%ДатаЗавершенияЭксплуатации%", Формат(ДатаЗавершенияЭксплуатации, "ДЛФ=D"));
	Шаблон = СтрЗаменить(Шаблон, "%НалоговоеНазначение%", НалоговоеНазначение);
		
	Наименование = Шаблон;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли