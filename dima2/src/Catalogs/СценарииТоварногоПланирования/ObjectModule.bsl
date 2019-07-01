#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	Если НЕ ИспользоватьВПланированииЗакупок И ИспользоватьДляЗаказовПоставщику Тогда
		ИспользоватьДляЗаказовПоставщику = Ложь;
	КонецЕсли; 
	
	Если (ПланЗакупокПланироватьПоСумме ИЛИ ПланПродажПланироватьПоСумме) 
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		И Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			ВызватьИсключение НСтр("ru='Не удалось заполнить поле ""Валюта"". Установите валюту управленческого учета!';uk='Не вдалося заповнити поле ""Валюта"". Встановіть валюту управлінського обліку!'");
		КонецЕсли;
	КонецЕсли;
	
	Если Периодичность = Перечисления.Периодичность.Год
		ИЛИ Периодичность = Перечисления.Периодичность.Декада Тогда
	
		ОтображатьНомерПериода = Ложь;
	КонецЕсли;
	
	Если НЕ ИспользоватьВПланированииПродажПоКатегориям Тогда
		ИспользоватьРасчетПоСкоростиПродаж = Ложь;
	КонецЕсли;
	
	//++ НЕ УТ
	Если НЕ ОтражаетсяВБюджетировании Тогда
		СценарийБюджетирования = Неопределено;
	КонецЕсли;
	
	Если Не ИспользоватьВПланированииПроизводства Тогда
		ИспользоватьДляПланированияМатериалов = Ложь;
		ИспользоватьДляЗаказовНаПроизводство = Ложь;
		ИспользоватьДляЗаказовНаВнутреннееПотребление = Ложь;
	КонецЕсли;
	//-- НЕ УТ
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если НЕ (ПланЗакупокПланироватьПоСумме ИЛИ ПланПродажПланироватьПоСумме) Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Валюта");
	КонецЕсли; 
	
	//++ НЕ УТ
	Если НЕ ОтражаетсяВБюджетировании Тогда
		МассивНепроверяемыхРеквизитов.Добавить("СценарийБюджетирования");
	КонецЕсли;
	//-- НЕ УТ
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если (ПланЗакупокПланироватьПоСумме ИЛИ ПланПродажПланироватьПоСумме)  
		И Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоВалют")
		И Не ЗначениеЗаполнено(Валюта) Тогда
		Валюта = ДоходыИРасходыСервер.ПолучитьВалютуУправленческогоУчета(Валюта);
		Если Не ЗначениеЗаполнено(Валюта) Тогда
			ВызватьИсключение НСтр("ru='Не удалось заполнить поле ""Валюта"". Установите валюту управленческого учета!';uk='Не вдалося заповнити поле ""Валюта"". Встановіть валюту управлінського обліку!'");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
