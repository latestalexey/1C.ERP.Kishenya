
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("МодельБюджетирования") Тогда
		Объект.МодельБюджетирования = Параметры.МодельБюджетирования;
	КонецЕсли;
	
	Группировки = "Вариант1";
	
	ТекущаяДата = ТекущаяДатаСеанса(); 
	НачалоПериода = ТекущаяДата;
	КонецПериода = ТекущаяДата;
	
	УправлениеФормой();
	
	Если Параметры.Свойство("СформироватьПриОткрытии")
		И Параметры.СформироватьПриОткрытии Тогда
		
		Если ЗначениеЗаполнено(Объект.МодельБюджетирования) Тогда
			Элементы.ГруппаПанельНастроек.Видимость = Ложь;
			СформироватьНаСервере();
			Параметры.СформироватьПриОткрытии = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьТекстПримечения();
	ЗаполнитьСведенияОЗадачах();
	
	Результат.ОтображатьЛегенду = Ложь;
	Результат.ОтображатьЗаголовок = Ложь;
	
	Результат.ОбластьПостроения.Право = 1;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	Если ЗначениеЗаполнено(Объект.МодельБюджетирования) Тогда
		Настройки.Удалить("Объект.МодельБюджетирования");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УправлениеФормой();
	Если ЗначениеЗаполнено(Объект.МодельБюджетирования) Тогда
		ЗаполнитьСведенияОЗадачах();
		Если Параметры.Свойство("СформироватьПриОткрытии")
			И Параметры.СформироватьПриОткрытии Тогда
			Элементы.ГруппаПанельНастроек.Видимость = Ложь;
			СформироватьНаСервере();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПериодНачалоВыбораЗавершение", ЭтотОбъект);
	
	ОбщегоНазначенияУТКлиент.ВыбратьПериодИзСписка(
				ЭтаФорма,
				Элемент,
				ВидПериода,
				НачалоПериода,
				ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура ВидПериодаПриИзменении(Элемент)
	
	ПривестиЗначениеПериода(ВидПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровки, СтандартнаяОбработка, Дата)
	
	Если ТипЗнч(Расшифровки) = Тип("Строка") Тогда
		ПоказатьПредупреждение(, Расшифровки);
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = ТипЗнч(Расшифровки) <> Тип("Массив");
	Если Не СтандартнаяОбработка Тогда
		СписокРезультат = Новый СписокЗначений;
		Для Каждого Расшифровка из Расшифровки Цикл
			Если ТипЗнч(Расшифровка) = Тип("СписокЗначений") Тогда
				Для Каждого Элемент из Расшифровка Цикл
					ЗаполнитьЗначенияСвойств(СписокРезультат.Добавить(), Элемент);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		Если СписокРезультат.Количество() = 1 Тогда
			ПоказатьЗначение(Неопределено, СписокРезультат[0].Значение);
		ИначеЕсли СписокРезультат.Количество() Тогда
			ВыбранноеЗначение = Неопределено;

			СписокРезультат.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("РезультатОбработкаРасшифровкиЗавершение", ЭтотОбъект), НСтр("ru='Сведения о шаге процесса';uk='Відомості про крок процесу'"));
		Иначе
			ПоказатьПредупреждение(,НСтр("ru='Нет данных для расшифровки!';uk='Немає даних для розшифровки!'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровкиЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
    
    ВыбранноеЗначение = ВыбранныйЭлемент;
    Если ВыбранноеЗначение <> Неопределено Тогда
        ПоказатьЗначение(Неопределено, ВыбранноеЗначение.Значение);
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТекущиеНевыполненныеЗадачиНажатие(Элемент)
	
	ФиксированныеНастройки = Новый НастройкиКомпоновкиДанных;
	
	ЭлементОтбора = ФиксированныеНастройки.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МодельБюджетирования");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Объект.МодельБюджетирования;
	ЭлементОтбора.Использование = Истина;
	
	Парам = Новый Структура;
	Парам.Вставить("КлючВарианта", "ТекущиеЗадачиРасшифровка");
	Парам.Вставить("СформироватьПриОткрытии", Истина);
	Парам.Вставить("ФиксированныеНастройки", ФиксированныеНастройки);
	Парам.Вставить("ВидимостьКомандВариантовОтчетов", Ложь);
	ОткрытьФорму("Отчет.ВыполнениеЗадачБюджетногоПроцесса.Форма", Парам);
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаШаговБюджетногоПроцессаНажатие(Элемент)
	
	ПараметрыФормы = Новый Структура("Отбор", Новый Структура("Владелец", Объект.МодельБюджетирования));
	ПараметрыФормы.Вставить("ЗакрыватьПриЗакрытииВладельца", Истина);
	ОткрытьФорму("Справочник.ЭтапыПодготовкиБюджетов.Форма.ФормаСписка", ПараметрыФормы, ЭтаФорма, Объект.МодельБюджетирования);
	
КонецПроцедуры

&НаКлиенте
Процедура МодельБюджетированияПриИзменении(Элемент)
	
	МодельБюджетированияПриИзмененииСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипОтчетаПриИзменении(Элемент)
	
	УправлениеФормой();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппировкиПриИзменении(Элемент)
	
	ГруппировкиПриИзмененииСервер();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	Перем Ошибки;
	
	// &ЗамерПроизводительности
	ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени(
		"Обработка.МониторБюджетныхПроцессов.ФормаОтчета.Команда.СформироватьОтчет");
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.МодельБюджетирования) Тогда
	
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"МодельБюджетирования",
			НСтр("ru='Не указана модель бюджетирования';uk='Не зазначена модель бюджетування'"), "");

		Отказ = Истина;
			
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(КонецПериода) Тогда
			
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"ВидПериода",
			НСтр("ru='Не указана дата окончания отчета';uk='Не вказана дата закінчення звіту'"), "");
			
		Отказ = Истина;
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Группировки) Тогда
			
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки,
			"Группировки",
			НСтр("ru='Не указаны группировки отчета';uk='Не зазначені групування звіту'"), "");
			
		Отказ = Истина;
		
	КонецЕсли;
	
	Если не Отказ Тогда
		СформироватьНаСервере();
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПанельНастроек(Команда)
	
	Элементы.ГруппаПанельНастроек.Видимость = Не Элементы.ГруппаПанельНастроек.Видимость;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура МодельБюджетированияПриИзмененииСервер()
	
	ЗаполнитьСведенияОЗадачах();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура ГруппировкиПриИзмененииСервер()
	
	УстановитьТекстПримечения();
	УправлениеФормой();
	
КонецПроцедуры

&НаСервере
Процедура УправлениеФормой()
	
	Модель = Объект.МодельБюджетирования;
	
	Если Группировки = "Вариант1" 
		И ЗначениеЗаполнено(Модель) Тогда
		Структура = Новый Структура("ПериодичностьПредставление, Периодичность", "Представление(Периодичность)", "Периодичность");
		Реквизиты = ОбщегоНазначенияУТВызовСервера.ЗначенияРеквизитовОбъекта(Модель, Структура);
		НовыйВидПериода = Перечисления.ДоступныеПериодыОтчета[ОбщегоНазначения.ИмяЗначенияПеречисления(Реквизиты.Периодичность)];
		Если ВидПериода <> НовыйВидПериода Тогда
			ВидПериода = НовыйВидПериода;
			ПривестиЗначениеПериода(ВидПериода);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ВидПериода.Доступность = Группировки <> "Вариант1";
	Элементы.ПоказатьПланВыполненияПроцесса.Видимость = ТипОтчета > 0;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	
	ДопПараметры = Новый Структура();
	ДопПараметры.Вставить("ПланВыполнения", 		ПоказатьПланВыполненияПроцесса);
	ДопПараметры.Вставить("ФлагИсполнитель", 		ОтветственныйФлаг);
	ДопПараметры.Вставить("ЗначениеИсполнитель", 	ОтветственныйЗначение);
	
	Обработки.МониторБюджетныхПроцессов.ЗаполнитьДиаграмму(
													Объект.МодельБюджетирования, Результат, 
													НачалоПериода, КонецПериода, 
													ТипОтчета, Группировки, ДопПараметры);
	
	ЗаполнитьСведенияОЗадачах();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьТекстПримечения()
	
	Если Группировки = "Вариант1" Тогда
		ТекстПримечания = НСтр("ru='В отчете отображаются все задачи, период планирования которых 
            |входит в период отчета. На диаграмму будут выведены задачи, 
            |которые начинаются до периода планирования или заканчиваются после.
            |Вариант отчета предназначен для обзора всех задач бюджетного процесса'
            |;uk='У звіті відображаються всі задачі, період планування яких 
            |входить у період звіту. На діаграму будуть виведені задачі, 
            |які починаються до періоду планування або закінчуються після.
            |Варіант звіту призначений для огляду всіх задач бюджетного процесу'");
	Иначе
		ТекстПримечания = НСтр("ru='В отчете отображаются все задачи, период выполнения которых 
            |входит в период отчета.
            |Вариант отчета предназначен для контроля исполнения задач бюджетного процесса'
            |;uk='У звіті відображаються всі задачі, термін виконання яких 
            |входить у період звіту.
            |Варіант звіту призначений для контролю виконання задач бюджетного процесу'");
	КонецЕсли;
	
	Элементы.ПримечаниеКВариантуОтчета.Заголовок = ТекстПримечания;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСведенияОЗадачах()
	
	Компановка = Отчеты.ВыполнениеЗадачБюджетногоПроцесса.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	Настройки = Новый НастройкиКомпоновкиДанных;
	
	ГруппировкаДетали = Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ГруппировкаДетали.Использование = Истина;
	
	ВыбранноеПоле = ГруппировкаДетали.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("НеВыполнено");
	ВыбранноеПоле.Заголовок = "НеВыполнено";

 	ВыбранноеПоле = ГруппировкаДетали.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Использование = Истина;
	ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Просроченные");
	ВыбранноеПоле.Заголовок = "Просроченные";
	
	Отбор = Настройки.Отбор;
	НовыйОтбор = Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("МодельБюджетирования");
	НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	НовыйОтбор.ПравоеЗначение = Объект.МодельБюджетирования;
	НовыйОтбор.Использование = Истина;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(Компановка, Настройки, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	ПроцессорКомпоновки.Сбросить();
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	Таблица = Новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(Таблица);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ШаблонЗаголовка = НСтр("ru='Выполняется задач: %1, из них просрочено: %2';uk='Виконується задач: %1, з них прострочено: %2'");
	
	Элементы.ТекущиеНевыполненныеЗадачи.Заголовок = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонЗаголовка, Таблица.Итог("НеВыполнено"), Таблица.Итог("Просроченные"));
	
КонецПроцедуры

&НаСервере
Процедура ПривестиЗначениеПериода(ВидПериода)
	
	НачалоПериода = ОбщегоНазначенияУТКлиентСервер.НачалоПериодаОтчета(ВидПериода, НачалоПериода);
	КонецПериода =  ОбщегоНазначенияУТКлиентСервер.КонецПериодаОтчета(ВидПериода, НачалоПериода);
	
	СписокПериодов = ОбщегоНазначенияУТКлиентСервер.ПолучитьСписокПериодов(НачалоПериода, ВидПериода);
	ЭлементСписка = СписокПериодов.НайтиПоЗначению(НачалоПериода);
	
	Если ЭлементСписка = Неопределено Тогда
		Период = "";
	Иначе
		Период = ЭлементСписка.Представление;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПериодНачалоВыбораЗавершение(ВыбранныйПериод, ДополнительныеПараметры) Экспорт

	Если ВыбранныйПериод <> Неопределено Тогда
		
		Период = ВыбранныйПериод.Представление;
		
		НачалоПериода = ВыбранныйПериод.Значение;
		КонецПериода = ОбщегоНазначенияУТКлиентСервер.КонецПериодаОтчета(ВидПериода, ВыбранныйПериод.Значение);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти
