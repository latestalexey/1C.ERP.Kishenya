
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	НазваниеСправочникаБанки = ИмяПрикладногоСправочника("Банки");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаБанки) Тогда
		НазваниеСправочникаБанки = "КлассификаторБанковРФ";
	КонецЕсли;
	
	НазваниеСправочникаКонтрагенты = ИмяПрикладногоСправочника("Контрагенты");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаКонтрагенты) Тогда
		НазваниеСправочникаКонтрагенты = "Контрагенты";
	КонецЕсли;
	НазваниеСправочникаОрганизации = ИмяПрикладногоСправочника("Организации");
	Если Не ЗначениеЗаполнено(НазваниеСправочникаОрганизации) Тогда
		НазваниеСправочникаОрганизации = "Организации";
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + НазваниеСправочникаКонтрагенты) Тогда
		ПараметрыФормы.Вставить("Контрагент", ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + НазваниеСправочникаОрганизации) Тогда
		ПараметрыФормы.Вставить("Организация", ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + НазваниеСправочникаБанки) Тогда
		ПараметрыФормы.Вставить("Банк", ПараметрКоманды);
	ИначеЕсли ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка.ПрофилиНастроекЭДО") Тогда
		ПараметрыФормы.Вставить("ПрофильНастроекЭДО", ПараметрКоманды);
	КонецЕсли;
	
	Если ИспользуетсяДополнительнаяАналитикаКонтрагентов() Тогда
		НазваниеСправочникаПартнеры = ИмяПрикладногоСправочника("Партнеры");
		Если ТипЗнч(ПараметрКоманды) = Тип("СправочникСсылка." + НазваниеСправочникаПартнеры) Тогда
			ПараметрыФормы.Вставить("Партнер", ПараметрКоманды);
		КонецЕсли;
	КонецЕсли;
	
	ПараметрыФормы.Вставить("НеОтображатьБыстрыеОтборы");
	
	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.ФормаСписка",
		ПараметрыФормы,
		ПараметрыВыполненияКоманды.Источник,
		ПараметрыВыполненияКоманды.Уникальность,
		ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИмяПрикладногоСправочника(Название)
	
	Возврат ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника(Название);
	
КонецФункции

&НаСервере
Функция ИспользуетсяДополнительнаяАналитикаКонтрагентов()
	
	Возврат ОбменСКонтрагентамиПовтИсп.ИспользуетсяДополнительнаяАналитикаКонтрагентовСправочникПартнеры();
	
КонецФункции

#КонецОбласти
