#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Организация") Тогда
			ДанныеЗаполнения.Вставить("Владелец", ДанныеЗаполнения.Организация);
		КонецЕсли;
	КонецЕсли;
	
	ВалютаДенежныхСредств = ЗначениеНастроекПовтИсп.ПолучитьВалютуРегламентированногоУчета(ВалютаДенежныхСредств);
	
	ДенежныеСредстваСервер.ОбработкаЗаполненияСправочников(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	Если НЕ ПоОбособленномуПодразделению Тогда
		МассивНепроверяемыхРеквизитов.Добавить("ОбособленноеПодразделениеОрганизации");
	КонецЕсли;
	
	Если НЕ ЗначениеНастроекПовтИсп.УказыватьНаправлениеНаБанковскихСчетахИКассах() Тогда
		МассивНепроверяемыхРеквизитов.Добавить("НаправлениеДеятельности");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ЭтоБазовая = ПолучитьФункциональнуюОпцию("БазоваяВерсия");
	
	Если Не ПолучитьФункциональнуюОпцию("ИспользоватьНесколькоКасс") Тогда
		УстановитьПривилегированныйРежим(Истина);
 		Запрос = Новый Запрос(
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Кассы.Ссылка
		|ИЗ
		|	Справочник.Кассы КАК Кассы
		|ГДЕ
		|	Кассы.Ссылка <> &Ссылка
		|	И НЕ Кассы.ПометкаУдаления");
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Если Не Запрос.Выполнить().Пустой() и Не ЭтоБазовая Тогда
			Константы.ИспользоватьНесколькоКасс.Установить(Истина);
		КонецЕсли;
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли