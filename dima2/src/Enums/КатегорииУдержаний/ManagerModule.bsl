#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка,
	|	ТаблицаКатегорий.Синоним
	|ПОМЕСТИТЬ ВТТаблицаКатегорий
	|ИЗ
	|	&ТаблицаКатегорий КАК ТаблицаКатегорий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаКатегорий.Ссылка
	|ИЗ
	|	ВТТаблицаКатегорий КАК ТаблицаКатегорий
	|ГДЕ
	|	ТаблицаКатегорий.Ссылка В(&ДействующиеКатегории)
	|	И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска";
	
	Если Параметры.СтрокаПоиска = Неопределено Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И ТаблицаКатегорий.Синоним ПОДОБНО &СтрокаПоиска", "");
	КонецЕсли;
	
	// Составляем таблицу категорий.
	ТаблицаКатегорий = Новый ТаблицаЗначений;
	ТаблицаКатегорий.Колонки.Добавить("Ссылка", Новый ОписаниеТипов("ПеречислениеСсылка.КатегорииУдержаний"));
	ТаблицаКатегорий.Колонки.Добавить("Синоним", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(256)));
	
	Для Каждого ЗначениеПеречисления Из Метаданные.Перечисления.КатегорииУдержаний.ЗначенияПеречисления Цикл
		НоваяСтрока = ТаблицаКатегорий.Добавить();
		НоваяСтрока.Ссылка = Перечисления.КатегорииУдержаний[ЗначениеПеречисления.Имя];
		НоваяСтрока.Синоним = ЗначениеПеречисления.Синоним;
	КонецЦикла;
	
	// Отбор только по действующим категориям с учетом введенной строки.
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("ТаблицаКатегорий", ТаблицаКатегорий);
	Запрос.УстановитьПараметр("ДействующиеКатегории", ДействующиеКатегории());
	Запрос.УстановитьПараметр("СтрокаПоиска", Строка(Параметры.СтрокаПоиска) + "%");
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДействующиеКатегории()
	
	МассивКатегорий = Новый Массив;
	
	ИспользоватьРасчетСохраняемогоДенежногоСодержания = ПолучитьФункциональнуюОпцию("ИспользоватьРасчетСохраняемогоДенежногоСодержания");
	
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ПрофсоюзныеВзносы);
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ИсполнительныйЛист);
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ВознаграждениеПлатежногоАгента);
	Если ИспользоватьРасчетСохраняемогоДенежногоСодержания Тогда
		МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ДенежноеСодержаниеУдержаниеЗаНеотработанныеДниОтпуска);
	КонецЕсли;
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.УдержаниеЗаНеотработанныеДниОтпуска);
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ДСВ);
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ДобровольныеВзносыВНПФ);
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.ПрочееУдержаниеВПользуТретьихЛиц);
	МассивКатегорий.Добавить(Перечисления.КатегорииУдержаний.УдержаниеВСчетРасчетовПоПрочимОперациям);
	
	Возврат МассивКатегорий;
	
КонецФункции

#КонецОбласти

#КонецЕсли