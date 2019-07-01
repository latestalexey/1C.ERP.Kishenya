#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ИспользоватьФорматыМагазинов = ПолучитьФункциональнуюОпцию("ИспользоватьФорматыМагазинов");
	
	Для каждого РСЗапись Из ЭтотОбъект Цикл
		
		Если НЕ ЗначениеЗаполнено(РСЗапись.Автор) Тогда
			РСЗапись.Автор = ПользователиКлиентСервер.ТекущийПользователь();
		КонецЕсли;
		
		РСЗапись.ДатаЗаписи = ТекущаяДата();
		
		Если ИспользоватьФорматыМагазинов И РСЗапись.КонтролироватьАссортимент И НЕ ЗначениеЗаполнено(РСЗапись.ФорматМагазина) Тогда
			
			ТекстОшибки = НСтр("ru='Поле ""Формат магазина"" не заполнено.';uk='Полі ""Формат магазину"" не заповнено.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,
				, 
				"ФорматМагазина",
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("ЭтотОбъект",РСЗапись.НомерСтроки,"ФорматМагазина"),
				Отказ);
		
		КонецЕсли; 
	
	КонецЦикла; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Для каждого РСЗапись Из ЭтотОбъект Цикл
		
		ТипСклада = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РСЗапись.Склад, "ТипСклада");
		ЭтоРозничныйСклад = (ТипСклада = Перечисления.ТипыСкладов.РозничныйМагазин);
		
		Если РСЗапись.КонтролироватьАссортимент И НЕ ЭтоРозничныйСклад Тогда
			
			РСЗапись.КонтролироватьАссортимент = Ложь;
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли