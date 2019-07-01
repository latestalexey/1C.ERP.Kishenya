
#Область СлужебныеПроцедурыИФункции

// Серверный обработчик события ОбработкаПолученияДанныхВыбора перечисления ФормыОткрываемыеПриНачалеРаботыСистемы.
//
Процедура ФормыОткрываемыеПриНачалеРаботыСистемыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	
	Если ПолучитьФункциональнуюОпцию("БазоваяВерсия") Тогда
		СтандартнаяОбработка = Ложь;
		ОткрытиеФормПриНачалеРаботыСистемы.ПолучитьМассивИспользуемыхФорм(ДанныеВыбора, Параметры);
	КонецЕсли;
	
КонецПроцедуры

// Возвращает имя формы, которую необходимо открыть для выполнения настройки программы при первом запуске.
//
Функция ФормаНачальнойНастройкиПрограммы() Экспорт
	
	// Установим служебные константы до выполнения всех обработчиков обновления
	Если ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы() Тогда
		ОбновлениеИнформационнойБазыУТ.УстановитьСлужебныеКонстанты();
	КонецЕсли;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	// Вернем имя формы помощника первого запуска
	УстановитьПривилегированныйРежим(Истина);
	
	ИмяФормы = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1 КАК Количество
	|ИЗ
	|	РегистрСведений.ВерсииПодсистем КАК ВерсииПодсистем
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	РегистрСведений.УдалитьВерсииПодсистем КАК УдалитьВерсииПодсистем";
	
	Если Запрос.Выполнить().Пустой() Тогда
		
		Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
			ИмяФормы = "";
		ИначеЕсли ОбщегоНазначенияУТ.ИДКонфигурации() = "УП2" Тогда
			ИмяФормы = "Обработка.ПомощникЗаполненияНастроекИСправочников.Форма.Форма"; // первый запуск УП (ERP)
		ИначеЕсли ОбщегоНазначенияУТ.ИДКонфигурации() = "КА2" Тогда
			ИмяФормы = ""; // первый запуск КА2
		Иначе
			ИмяФормы = "ОбщаяФорма.ВыборВариантаНастройкиПрограммы"; // первый запуск УТ11
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ИмяФормы;
	
КонецФункции

#КонецОбласти
