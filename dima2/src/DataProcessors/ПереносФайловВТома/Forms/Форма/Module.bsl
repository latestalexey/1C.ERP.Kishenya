
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЧислоВерсийВБазе = ПолучитьЧислоВерсийВБазе();
	ТипХраненияВТомах = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
	
	РазмерВерсийВБазеВБайтах = ПолучитьРазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	ДополнительныеПараметры = Новый Структура;
	
	ДополнительныеПараметры.Вставить(
		"ПриОткрытииХранитьФайлыВТомахНаДиске",
		ФайловыеФункцииСлужебный.ХранениеФайловВТомахНаДиске());
	
	ДополнительныеПараметры.Вставить(
		"ПриОткрытииЕстьТомаХраненияФайлов",
		ФайловыеФункции.ЕстьТомаХраненияФайлов());
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ДополнительныеПараметры.ПриОткрытииХранитьФайлыВТомахНаДиске Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не установлен тип хранения файлов ""В томах на диске""';uk='Не встановлений тип зберігання файлів ""У томах на диску""'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ ДополнительныеПараметры.ПриОткрытииЕстьТомаХраненияФайлов Тогда 
		ПоказатьПредупреждение(, НСтр("ru='Нет ни одного тома для размещения файлов';uk='Немає жодного тому для розміщення файлів'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПереносФайловВТома(Команда)
	
	СвойстваХраненияФайлов = СвойстваХраненияФайлов();
	
	Если СвойстваХраненияФайлов.ТипХраненияФайлов <> ТипХраненияВТомах Тогда
		ПоказатьПредупреждение(, НСтр("ru='Не установлен тип хранения файлов ""В томах на диске""';uk='Не встановлений тип зберігання файлів ""У томах на диску""'"));
		Возврат;
	КонецЕсли;
	
	Если НЕ СвойстваХраненияФайлов.ЕстьТомаХраненияФайлов Тогда
		ПоказатьПредупреждение(, НСтр("ru='Нет ни одного тома для размещения файлов';uk='Немає жодного тому для розміщення файлів'"));
		Возврат;
	КонецЕсли;
	
	Если ЧислоВерсийВБазе = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Нет ни одного файла в информационной базе';uk='Немає жодного файлу в інформаційній базі'"));
		Возврат;
	КонецЕсли;
	
	ТекстВопроса = НСтр("ru='Выполнить перенос файлов в информационной базе в тома хранения файлов?
    |
    |Эта операция может занять продолжительное время.'
    |;uk='Виконати перенесення файлів в інформаційній базі в тома зберігання файлів?
    |
    |Ця операція може зайняти тривалий час.'");
	Обработчик = Новый ОписаниеОповещения("ВыполнитьПереносФайловВТомаЗавершение", ЭтотОбъект);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыполнитьПереносФайловВТомаЗавершение(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Состояние(НСтр("ru='Выполняется получение списка файлов...';uk='Виконується отримання списку файлів...'"));
	
	МассивВерсий = ПолучитьМассивВерсийВБазе();
	НомерЦикла = 1;
	ЧислоПеренесенных = 0;
	
	ЧислоВерсийВПакете = 10;
	ПакетВерсий = Новый Массив;
	
	МассивФайловСОшибками = Новый Массив;
	ОбработкаПрервана = Ложь;
	
	Для Каждого ВерсияСтруктура Из МассивВерсий Цикл
		
		Прогресс = 0;
		Если ЧислоВерсийВБазе <> 0 Тогда
			Прогресс = Окр(НомерЦикла * 100 / ЧислоВерсийВБазе, 2);
		КонецЕсли;
		
		Состояние(НСтр("ru='Выполняется перенос файла в том...';uk='Виконується перенесення файлу до тому...'"), Прогресс, ВерсияСтруктура.Текст, БиблиотекаКартинок.УстановитьВремя);
		
		ПакетВерсий.Добавить(ВерсияСтруктура);
		
		Если ПакетВерсий.Количество() >= ЧислоВерсийВПакете Тогда
			ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
			
			Если ЧислоПеренесенныхВПакете = 0 И ПакетВерсий.Количество() = ЧислоВерсийВПакете Тогда
				ОбработкаПрервана = Истина; // Весь пакет не смогли перенести - прекращаем операцию.
				Прервать;
			КонецЕсли;
			
			ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
			ПакетВерсий.Очистить();
			
		КонецЕсли;
		
		НомерЦикла = НомерЦикла + 1;
	КонецЦикла;
	
	Если ПакетВерсий.Количество() <> 0 Тогда
		ЧислоПеренесенныхВПакете = ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками);
		
		Если ЧислоПеренесенныхВПакете = 0 Тогда
			ОбработкаПрервана = Истина; // Весь пакет не смогли перенести - прекращаем операцию.
		КонецЕсли;
		
		ЧислоПеренесенных = ЧислоПеренесенных + ЧислоПеренесенныхВПакете;
		ПакетВерсий.Очистить();
	КонецЕсли;
	
	ЧислоВерсийВБазе = ПолучитьЧислоВерсийВБазе();
	РазмерВерсийВБазеВБайтах = ПолучитьРазмерВерсийВБазе();
	РазмерВерсийВБазе = РазмерВерсийВБазеВБайтах / 1048576;
	
	Если ЧислоПеренесенных <> 0 Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Завершен перенос файлов в тома.
                       |Перенесено файлов: %1'
                       |;uk='Завершене перенесення файлів в тома.
                       |Перенесено файлів: %1'"),
			ЧислоПеренесенных);
		ПоказатьПредупреждение(, ТекстПредупреждения);
	КонецЕсли;
	
	Если МассивФайловСОшибками.Количество() <> 0 Тогда
		
		Пояснение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Количество ошибок при переносе: %1';uk='Кількість помилок при перенесенні: %1'"),
			МассивФайловСОшибками.Количество());
			
		Если ОбработкаПрервана Тогда
			Пояснение = НСтр("ru='Не удалось перенести ни одного файла из пакета.
                                   |Перенос прерван.'
                                   |;uk='Не вдалося перенести жодного файлу з пакету.
                                   |Перенесення перерване.'");
		КонецЕсли;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Пояснение", Пояснение);
		ПараметрыФормы.Вставить("МассивФайловСОшибками", МассивФайловСОшибками);
		
		ОткрытьФорму("Обработка.ПереносФайловВТома.Форма.ФормаОтчета", ПараметрыФормы);
		
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРазмерВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЕСТЬNULL(СУММА(ВерсииФайлов.Размер), 0) КАК Размер
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Размер;
	
КонецФункции

&НаСервере
Функция ПолучитьЧислоВерсийВБазе()
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(*) КАК Количество
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;	
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Количество;
	
КонецФункции

&НаСервере
Функция ПолучитьМассивВерсийВБазе()
	
	МассивВерсий = Новый Массив;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВерсииФайлов.Ссылка КАК Ссылка,
		|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
		|	ВерсииФайлов.Размер КАК Размер
		|ИЗ
		|	Справочник.ВерсииФайлов КАК ВерсииФайлов
		|ГДЕ
		|	ВерсииФайлов.ТипХраненияФайла = &ТипХраненияФайла";
	Запрос.УстановитьПараметр("ТипХраненияФайла", Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе);
	
	Результат = Запрос.Выполнить();
	ТаблицаВыгрузки = Результат.Выгрузить();
	
	Для Каждого Строка Из ТаблицаВыгрузки Цикл
		ВерсияСтруктура = Новый Структура("Ссылка, Текст, Размер", 
			Строка.Ссылка, Строка.ПолноеНаименование, Строка.Размер);
		МассивВерсий.Добавить(ВерсияСтруктура);
	КонецЦикла;
	
	Возврат МассивВерсий;
	
КонецФункции

&НаСервереБезКонтекста
Функция СвойстваХраненияФайлов()
	
	СвойстваХраненияФайлов = Новый Структура;
	
	СвойстваХраненияФайлов.Вставить(
		"ТипХраненияФайлов", ФайловыеФункцииСлужебный.ТипХраненияФайлов());
	
	СвойстваХраненияФайлов.Вставить(
		"ЕстьТомаХраненияФайлов", ФайловыеФункции.ЕстьТомаХраненияФайлов());
	
	Возврат СвойстваХраненияФайлов;
	
КонецФункции

&НаСервере
Функция ПеренестиМассивВерсийВТом(ПакетВерсий, МассивФайловСОшибками)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ЧислоОбработанных = 0;
	МаксимальныйРазмерФайла = ФайловыеФункции.МаксимальныйРазмерФайла();
	
	Для Каждого ВерсияСтруктура Из ПакетВерсий Цикл
		
		Если ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками) Тогда
			ЧислоОбработанных = ЧислоОбработанных + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ЧислоОбработанных;
	
КонецФункции

&НаСервере
Функция ПеренестиВерсиюВТом(ВерсияСтруктура, МаксимальныйРазмерФайла, МассивФайловСОшибками)
	
	КодВозврата = Истина;
	
	ВерсияСсылка = ВерсияСтруктура.Ссылка;
	ФайлСсылка = ВерсияСсылка.Владелец;
	Размер = ВерсияСтруктура.Размер;
	ИмяДляЖурнала = "";
	
	Если Размер > МаксимальныйРазмерФайла Тогда
		
		ИмяДляЖурнала = ВерсияСтруктура.Текст;
		ЗаписьЖурналаРегистрации(НСтр("ru='Файлы.Ошибка переноса файла в том';uk='Файли.Помилка перенесення файлу в том'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При переносе в том файла
                           |""%1""
                           |возникла ошибка:
                           |""Размер превышает максимальный"".'
                           |;uk='При перенесенні в том файлу
                           |""%1""
                           |виникла помилка:
                           |""Розмір перевищує максимальний"".'"),
				ИмяДляЖурнала));
		
		Возврат Ложь; // ничего не сообщаем 
	КонецЕсли;
	
	ИмяДляЖурнала = ВерсияСтруктура.Текст;
	ЗаписьЖурналаРегистрации(НСтр("ru='Файлы.Начат перенос файла в том';uk='Файли.Розпочато переміщення файлу в том'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
		УровеньЖурналаРегистрации.Информация,, ФайлСсылка,
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Начат перенос в том файла
                       |""%1"".'
                       |;uk='Почато перенесення в том файлу
                       |""%1"".'"),
			ИмяДляЖурнала));
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ФайлСсылка);
	Исключение
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	Попытка
		ЗаблокироватьДанныеДляРедактирования(ВерсияСсылка);
	Исключение
		РазблокироватьДанныеДляРедактирования(ФайлСсылка);
		Возврат Ложь; // ничего не сообщаем 
	КонецПопытки;
	
	ТипХраненияФайла = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ВерсияСсылка, "ТипХраненияФайла");
	Если ТипХраненияФайла <> Перечисления.ТипыХраненияФайлов.ВИнформационнойБазе Тогда
		// Тут файл на диске - так не должно быть.
		РазблокироватьДанныеДляРедактирования(ФайлСсылка);
		РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
		Возврат Ложь;
	КонецЕсли;
	
	НачатьТранзакцию();
	
	Попытка
		
		ВерсияОбъект = ВерсияСсылка.ПолучитьОбъект();
		ХранилищеФайла = РаботаСФайламиСлужебныйВызовСервера.ПолучитьХранилищеФайлаИзИнформационнойБазы(ВерсияСсылка);
		СведенияОФайле = ФайловыеФункцииСлужебный.ДобавитьФайлВТом(ХранилищеФайла.Получить(), ВерсияОбъект.ДатаМодификацииУниверсальная, 
			ВерсияОбъект.ПолноеНаименование, ВерсияОбъект.Расширение, ВерсияОбъект.НомерВерсии,	ФайлСсылка.Зашифрован, 
			// Чтобы все файлы не попали в одну папку за сегодняшний день - подставляем дату создания файла.
			ВерсияОбъект.ДатаМодификацииУниверсальная);
			
		ВерсияОбъект.Том = СведенияОФайле.Том;
		ВерсияОбъект.ПутьКФайлу = СведенияОФайле.ПутьКФайлу;
		ВерсияОбъект.ТипХраненияФайла = Перечисления.ТипыХраненияФайлов.ВТомахНаДиске;
		ВерсияОбъект.ФайлХранилище = Новый ХранилищеЗначения("");
		// Чтобы прошла запись ранее подписанного объекта.
		ВерсияОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
		ВерсияОбъект.Записать();
		
		ФайлОбъект = ФайлСсылка.ПолучитьОбъект();
		// Чтобы прошла запись ранее подписанного объекта.
		ФайлОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
		ФайлОбъект.Записать(); // Для переноса полей версии в файл.
		
		РаботаСФайламиСлужебныйВызовСервера.УдалитьЗаписьИзРегистраХранимыеФайлыВерсий(ВерсияСсылка);
		
		ЗаписьЖурналаРегистрации(
			НСтр("ru='Файлы.Завершен перенос файла в том';uk='Файли.Завершено перенесення файлу у том'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Информация,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Завершен перенос в том файла
                           |""%1"".'
                           |;uk='Завершене перенесення в том файлу
                           |""%1"".'"), ИмяДляЖурнала));
		
		ЗафиксироватьТранзакцию();
	Исключение
		ИнформацияОбОшибке = ИнформацияОбОшибке();
		ОтменитьТранзакцию();
		
		СтруктураОшибки = Новый Структура;
		СтруктураОшибки.Вставить("ИмяФайла", ИмяДляЖурнала);
		СтруктураОшибки.Вставить("Ошибка",   КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
		СтруктураОшибки.Вставить("Версия",   ВерсияСсылка);
		
		МассивФайловСОшибками.Добавить(СтруктураОшибки);
		
		ЗаписьЖурналаРегистрации(НСтр("ru='Файлы.Ошибка переноса файла в том';uk='Файли.Помилка перенесення файлу в том'",ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,, ФайлСсылка,
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='При переносе в том файла
                           |""%1""
                           |возникла ошибка:
                           |""%2"".'
                           |;uk='При перенесенні в том файлу
                           |""%1""
                           |виникла помилка:
                           |""%2"".'"),
				ИмяДляЖурнала,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке)));
				
		КодВозврата = Ложь;
		
	КонецПопытки;
	
	РазблокироватьДанныеДляРедактирования(ФайлСсылка);
	РазблокироватьДанныеДляРедактирования(ВерсияСсылка);
	
	Возврат КодВозврата;
	
КонецФункции

#КонецОбласти
