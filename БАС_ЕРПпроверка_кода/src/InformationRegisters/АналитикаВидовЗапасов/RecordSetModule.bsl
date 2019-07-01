#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	Если ЭтотОбъект[0].ТипЗапасов <> Перечисления.ТипыЗапасов.КомиссионныйТовар Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(
		ПроверяемыеРеквизиты,
		МассивНепроверяемыхРеквизитов);

КонецПроцедуры

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		Если Не ЗначениеЗаполнено(Запись.АналитикаПредназначения)
		 И Запись.АналитикаПредназначения <> Неопределено Тогда
			Запись.АналитикаПредназначения = Неопределено;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Запись.Поставщик)
		 И Запись.Поставщик <> Неопределено Тогда
			Запись.Поставщик = Неопределено;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
