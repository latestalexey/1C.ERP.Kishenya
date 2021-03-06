
#Область ПрограммныйИнтерфейс

#Область ЭтикеткиИЦенники

Функция ДанныеДляПечатиЦенниковИЭтикеток(Идентификатор, ОбъектыПечати, ДополнительныеПараметры) Экспорт
	
	МенеджерОбъекта = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(ДополнительныеПараметры.МенеджерПечати);
	
	Если Идентификатор = "Ценники" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЦенников(ОбъектыПечати);	
	ИначеЕсли Идентификатор = "Этикетки" Тогда
		Возврат МенеджерОбъекта.ДанныеДляПечатиЭтикеток(ОбъектыПечати);
	КонецЕсли;
	
КонецФункции

Функция ДанныеДляПечатиЭтикетокСкладскиеЯчейки(Идентификатор, ОбъектыПечати) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Владелец КАК Склад,
	|	СкладскиеЯчейки.Помещение
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В(&Ячейки)";
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() <> 1 Тогда
		ТекстИсключения = НСтр("ru='Выделены ячейки разных складских территорий (помещений).
            |Одновременно можно печатать этикетки только по ячейкам, принадлежащим одной складской территории (помещению).'
            |;uk='Виділені комірки різних складських територій (приміщень).
            |Одночасно можна друкувати етикетки тільки по комірках, що належать одніій складській території (приміщенню).'");
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
	Выборка.Следующий();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СкладскиеЯчейки.Ссылка КАК Ячейка
	|ИЗ
	|	Справочник.СкладскиеЯчейки КАК СкладскиеЯчейки
	|ГДЕ
	|	СкладскиеЯчейки.Ссылка В ИЕРАРХИИ(&Ячейки)
	|	И НЕ СкладскиеЯчейки.ПометкаУдаления
	|	И НЕ СкладскиеЯчейки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	СкладскиеЯчейки.Код";
	
	Запрос.УстановитьПараметр("Ячейки", ОбъектыПечати);
	
	ТаблицаЯчеек = Запрос.Выполнить().Выгрузить();
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Склад", 	  Выборка.Склад);
	СтруктураПараметров.Вставить("Помещение", Выборка.Помещение);
	СтруктураПараметров.Вставить("Ячейки",    ТаблицаЯчеек);
	
	Возврат ПоместитьВоВременноеХранилище(СтруктураПараметров);
	
КонецФункции

Функция ДанныеДляПечатиЭтикетокДоставки(Идентификатор, ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокДоставки(ОбъектыПечати[0]);
	
КонецФункции

Функция ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати) Экспорт
	
	Возврат Обработки.ПечатьЭтикетокИЦенников.ДанныеДляПечатиЭтикетокУпаковочныеЛисты(ОбъектыПечати);
	
КонецФункции

#КонецОбласти

#Область М21

Функция ПолучитьПараметрыФормирования(МассивПересчетов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивПересчетов", МассивПересчетов);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ПересчетТоваров.Ссылка КАК Ссылка,
	|	НАЧАЛОПЕРИОДА(ПересчетТоваров.Дата, ДЕНЬ) КАК Дата,
	|	ПересчетТоваров.Склад
	|ПОМЕСТИТЬ СписокПересчетов
	|ИЗ
	|	Документ.ПересчетТоваров КАК ПересчетТоваров
	|ГДЕ
	|	ПересчетТоваров.Ссылка В(&МассивПересчетов)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	ИнвентаризационнаяОпись.Ссылка,
	|	ИнвентаризационнаяОпись.Организация,
	|	ИнвентаризационнаяОпись.ДатаНачала,
	|	ИнвентаризационнаяОпись.ДатаОкончания,
	|	ИнвентаризационнаяОпись.Склад
	|ПОМЕСТИТЬ СписокОписей
	|ИЗ
	|	Документ.ИнвентаризационнаяОпись КАК ИнвентаризационнаяОпись
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокПересчетов КАК ПересчетТоваров
	|		ПО (ПересчетТоваров.Склад = ИнвентаризационнаяОпись.Склад)
	|			И (ПересчетТоваров.Дата МЕЖДУ ИнвентаризационнаяОпись.ДатаНачала И ИнвентаризационнаяОпись.ДатаОкончания)
	|ГДЕ
	|	ИнвентаризационнаяОпись.Проведен
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокОписей.Ссылка КАК Ссылка
	|ИЗ
	|	СписокОписей КАК СписокОписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписокПересчетов.Склад
	|ИЗ
	|	СписокПересчетов КАК СписокПересчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(СписокОписей.ДатаНачала) КАК ДатаНачала,
	|	МАКСИМУМ(СписокОписей.ДатаОкончания) КАК ДатаОкончания
	|ИЗ
	|	СписокОписей КАК СписокОписей
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МИНИМУМ(СписокПересчетов.Дата) КАК ДатаНачала,
	|	МАКСИМУМ(СписокПересчетов.Дата) КАК ДатаОкончания
	|ИЗ
	|	СписокПересчетов КАК СписокПересчетов
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СписокОписей.Организация
	|ИЗ
	|	СписокОписей КАК СписокОписей";
	Результат = Запрос.ВыполнитьПакет();
	
	ПараметрыФормирования = Новый Структура;
	ПараметрыФормирования.Вставить("Описи", Результат[2].Выгрузить().ВыгрузитьКолонку("Ссылка"));
	ПараметрыФормирования.Вставить("Склады", Результат[3].Выгрузить().ВыгрузитьКолонку("Склад"));
	Выборка = Результат[4].Выбрать();
	Выборка.Следующий();
	ПараметрыФормирования.Вставить("ДатаНачала", Выборка.ДатаНачала);
	ПараметрыФормирования.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
	Если НЕ ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала) Тогда
		Выборка = Результат[5].Выбрать();
		Выборка.Следующий();
		ПараметрыФормирования.Вставить("ДатаНачала", Выборка.ДатаНачала);
		ПараметрыФормирования.Вставить("ДатаОкончания", Выборка.ДатаОкончания);
	КонецЕсли;
	ПараметрыФормирования.Вставить("Организации", Результат[6].Выгрузить().ВыгрузитьКолонку("Организация"));
	
	Возврат ПараметрыФормирования;
	
КонецФункции

#КонецОбласти


#Область ТТН

Функция ПроверитьНаличиеТранспортныхНакладныхДляРаспоряженийИзЗаданийНаПеревозку(МассивОбъектов) Экспорт
	Возврат	Документы.ТранспортнаяНакладная.ПроверитьНаличиеТранспортныхНакладныхДляРаспоряженийИзЗаданийНаПеревозку(МассивОбъектов);
КонецФункции

Функция ПроверитьНаличиеТранспортныхНакладныхДляРаспоряжений(МассивОбъектов) Экспорт
	Возврат	Документы.ТранспортнаяНакладная.ПроверитьНаличиеТранспортныхНакладныхДляРаспоряжений(МассивОбъектов);
КонецФункции

Функция СоздатьТранспортныеНакладныеДляЗаданийНаПеревозку(МассивОбъектов) Экспорт
	ТранспортныеНакладные = Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладныеДляЗаданийНаПеревозку(МассивОбъектов);
	Возврат ТранспортныеНакладные;
КонецФункции

Функция СоздатьТранспортныеНакладные(МассивОбъектов) Экспорт
	ТранспортныеНакладные = Документы.ТранспортнаяНакладная.СоздатьТранспортныеНакладные(МассивОбъектов);
	Возврат ТранспортныеНакладные;
КонецФункции

Функция ПолучитьТранспортныеНакладныеНаПечать(ОбъектыПечати) Экспорт
	
	ТипДокументов = ТипЗнч(ОбъектыПечати[0]);
	МассивДокументовБезНакладных = Новый Массив;
	
	Запрос = Новый Запрос;
				
	Если ТипДокументов = Тип("ДокументСсылка.ЗаданиеНаПеревозку") Тогда
		
		Запрос.УстановитьПараметр("ЗаданияНаПеревозку",        ОбъектыПечати);
		Запрос.УстановитьПараметр("НетВыделенныхСтрокАдресов", Истина);
		Запрос.УстановитьПараметр("ВыделенныеСтрокиАдресов",   Новый Массив);
		Запрос.УстановитьПараметр("ВсеРаспоряжения",           Истина);
		Запрос.УстановитьПараметр("Распоряжения",              Новый Массив);
		
		Запрос.Текст = Документы.ЗаданиеНаПеревозку.ТекстЗапросаПолученияСпискаНакладныхИзЗаданийНаПеревозку() + 
		"ВЫБРАТЬ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка КАК ТранспортнаяНакладная,
		|	НакладныеПоЗаданиямНаПеревозку.ЗаданиеНаПеревозку КАК ДокументОснование,
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Дата КАК Дата,
		|	НакладныеПоЗаданиямНаПеревозку.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ТранспортныеНакладныеИОснования
		|ИЗ
		|	НакладныеПоЗаданиямНаПеревозку КАК НакладныеПоЗаданиямНаПеревозку
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
		|		ПО НакладныеПоЗаданиямНаПеревозку.Накладная = ТранспортнаяНакладнаяДокументыОснования.ДокументОснование
		|			И НакладныеПоЗаданиямНаПеревозку.ЗаданиеНаПеревозку = ТранспортнаяНакладнаяДокументыОснования.Ссылка.ЗаданиеНаПеревозку
		|ГДЕ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладныеИОснования.НомерСтроки КАК НомерСтроки,
		|	ТранспортныеНакладныеИОснования.ДокументОснование КАК ДокументОснование,
		|	ТранспортныеНакладныеИОснования.Дата
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранспортныеНакладныеИОснования.ДокументОснование,
		|	ТранспортныеНакладныеИОснования.НомерСтроки,
		|	ТранспортныеНакладныеИОснования.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ДокументОснование
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования";
		
		НомерТаблицыДокументыОснования = 4;
		НомерТаблицыТранспортныеНакладныеНаПечать = 3;
		
	Иначе
		
		Запрос.УстановитьПараметр("ОбъектыПечати", ОбъектыПечати);
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка КАК ТранспортнаяНакладная,
		|	ТранспортнаяНакладнаяДокументыОснования.Ссылка.Дата КАК Дата,
		|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование
		|ПОМЕСТИТЬ ТранспортныеНакладныеИОснования
		|ИЗ
		|	Документ.ТранспортнаяНакладная.ДокументыОснования КАК ТранспортнаяНакладнаяДокументыОснования
		|ГДЕ
		|	ТранспортнаяНакладнаяДокументыОснования.ДокументОснование В(&ОбъектыПечати)
		|	И НЕ ТранспортнаяНакладнаяДокументыОснования.Ссылка.ПометкаУдаления
		|	И ТранспортнаяНакладнаяДокументыОснования.Ссылка.Проведен
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ТранспортнаяНакладная КАК ТранспортнаяНакладная,
		|	ТранспортныеНакладныеИОснования.Дата
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранспортныеНакладныеИОснования.Дата
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ТранспортныеНакладныеИОснования.ДокументОснование
		|ИЗ
		|	ТранспортныеНакладныеИОснования КАК ТранспортныеНакладныеИОснования";
		
		НомерТаблицыДокументыОснования = 2;
		НомерТаблицыТранспортныеНакладныеНаПечать = 1;
				
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	УстановитьПривилегированныйРежим(Ложь);
	ДокументыОснования = РезультатЗапроса[НомерТаблицыДокументыОснования].Выгрузить().ВыгрузитьКолонку("ДокументОснование");
	ТаблицаТранспортныеНакладныеНаПечать = РезультатЗапроса[НомерТаблицыТранспортныеНакладныеНаПечать].Выгрузить();
	ТаблицаТранспортныеНакладныеНаПечать.Свернуть("ТранспортнаяНакладная");
	ТранспортныеНакладныеНаПечать = ТаблицаТранспортныеНакладныеНаПечать.ВыгрузитьКолонку("ТранспортнаяНакладная");
	
	Для	Каждого ОбъектПечати Из ОбъектыПечати Цикл
		
		Если ДокументыОснования.Найти(ОбъектПечати) = Неопределено Тогда
			МассивДокументовБезНакладных.Добавить(ОбъектПечати);	
		КонецЕсли;
		
	КонецЦикла;	 
	
	Структура = Новый Структура;
	Структура.Вставить("МассивДокументовБезНакладных", МассивДокументовБезНакладных);
	Структура.Вставить("ТранспортныеНакладныеНаПечать", ТранспортныеНакладныеНаПечать);
	
	Возврат Структура;	
	
КонецФункции

#КонецОбласти

#Область ПредставленияКоманд

Функция ПредставлениеКомандыПечатьАктВыполненныхРаботMicrosoftWord(АльтернативныйЯзык) Экспорт
	
	КодЯзыка = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();
	Если АльтернативныйЯзык Тогда
		КодЯзыка = ?(КодЯзыка = "uk", "ru", "uk");
	КонецЕсли; 
	Если КодЯзыка = "ru" Тогда
		КомандаПечатиПредставление  = НСтр("ru='Акт выполненных работ (Microsoft Word, русский язык)';uk='Акт виконаних робіт (Microsoft Word, російська мова)'");
	ИначеЕсли КодЯзыка = "uk" Тогда	
		КомандаПечатиПредставление  = НСтр("ru='Акт выполненных работ (Microsoft Word, украинский язык)';uk='Акт виконаних робіт (Microsoft Word, українська мова)'");
	КонецЕсли; 
	Возврат КомандаПечатиПредставление;
	
КонецФункции // ПредставлениеКомандыПечатьАктВыполненныхРаботMicrosoftWord

Функция ПредставлениеКомандыПечатьКоммерческоеПредложениеMicrosoftWord(АльтернативныйЯзык) Экспорт
	
	КодЯзыка = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();
	Если АльтернативныйЯзык Тогда
		КодЯзыка = ?(КодЯзыка = "uk", "ru", "uk");
	КонецЕсли; 
	Если КодЯзыка = "ru" Тогда
		КомандаПечатиПредставление  = НСтр("ru='Коммерческое предложение (Microsoft Word, русский язык)';uk='Комерційна пропозиція (Microsoft Word, російська мова)'");
	ИначеЕсли КодЯзыка = "uk" Тогда	
		КомандаПечатиПредставление  = НСтр("ru='Коммерческое предложение (Microsoft Word, украинский язык)';uk='Комерційна пропозиція (Microsoft Word, українська мова)'");
	КонецЕсли; 
	Возврат КомандаПечатиПредставление;
	
КонецФункции // ПредставлениеКомандыПечатьПечатьКоммерческоеПредложениеMicrosoftWord

Функция ПредставлениеКомандыПечатьКоммерческоеПредложениеOpenOfficeOrgWriter(АльтернативныйЯзык) Экспорт
	
	КодЯзыка = Локализация.ПолучитьЯзыкФормированияПечатныхФорм();
	Если АльтернативныйЯзык Тогда
		КодЯзыка = ?(КодЯзыка = "uk", "ru", "uk");
	КонецЕсли; 
	Если КодЯзыка = "ru" Тогда
		КомандаПечатиПредставление  = НСтр("ru='Коммерческое предложение (OpenOffice.org Writer, русский язык)';uk='Комерційна пропозиція (OpenOffice.org Writer, російська мова)'");
	ИначеЕсли КодЯзыка = "uk" Тогда	
		КомандаПечатиПредставление  = НСтр("ru='Коммерческое предложение (OpenOffice.org Writer, украинский язык)';uk='Комерційна пропозиція (OpenOffice.org Writer, українська мова)'");
	КонецЕсли; 
	Возврат КомандаПечатиПредставление;
	
КонецФункции // ПредставлениеКомандыПечатьКоммерческоеПредложениеOpenOfficeOrgWriter

#КонецОбласти

#КонецОбласти
