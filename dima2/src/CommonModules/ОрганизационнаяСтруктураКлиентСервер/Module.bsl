
#Область СлужебныеПроцедурыИФункции

Функция НаименованиеПозицииШтатногоРасписания(Организация, Должность, МестоВСтруктуреПредприятия) Экспорт 
	
	Шаблон = "%1";
	Если ЗначениеЗаполнено(МестоВСтруктуреПредприятия) Тогда
		Шаблон = Шаблон + " /%2/";
	КонецЕсли;
	Если ЗначениеЗаполнено(Организация) Тогда
		Шаблон = Шаблон + ", (%3)";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Шаблон, Должность, МестоВСтруктуреПредприятия, Организация);
	
КонецФункции

#КонецОбласти
