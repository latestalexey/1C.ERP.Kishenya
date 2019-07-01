#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СегментыСервер.ВключитьОтборПоСегментуНоменклатурыВСКД(КомпоновщикНастроек);

	СтандартнаяОбработка = Ложь;
	
	МассивЗаголовковРесурсов = Новый Массив;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	Для Каждого  ЭлементВыбора Из НастройкиОтчета.Выбор.Элементы Цикл

		Если Не ТипЗнч(ЭлементВыбора) = Тип("ВыбранноеПолеКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;

		Если СхемаКомпоновкиданных.ПоляИтога.Найти(ЭлементВыбора.Поле) <> Неопределено Тогда
			Если Не ПустаяСтрока(ЭлементВыбора.Заголовок) Тогда
				МассивЗаголовковРесурсов.Добавить(ЭлементВыбора.Заголовок);
			Иначе
				ПолеНабораДанных = СхемаКомпоновкиДанных.НаборыДанных.ВыручкаИСебестоимостьПродаж.Поля.найти(ЭлементВыбора.Поле);
				Если ПолеНабораДанных <> Неопределено Тогда
					МассивЗаголовковРесурсов.Добавить(ПолеНабораДанных.Заголовок);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;

	КонецЦикла;

	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);

	Для Каждого ТекМакет Из МакетКомпоновки.Макеты Цикл

		Если ТипЗнч(ТекМакет.Макет) <> Тип("МакетОбластиКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;

		Для Каждого СтрокаТаблицыКомпоновки Из ТекМакет.Макет Цикл
			Для Каждого ЯчейкаТаблицыОбластиКомпоновки Из СтрокаТаблицыКомпоновки.Ячейки Цикл
				Для Каждого Элемент Из ЯчейкаТаблицыОбластиКомпоновки.Элементы Цикл
					Если МассивЗаголовковРесурсов.Найти(Элемент.Значение) <> Неопределено Тогда

						Параметр = ЯчейкаТаблицыОбластиКомпоновки.Оформление.Элементы.Найти(Новый ПараметрКомпоновкиДанных("ГоризонтальноеПоложение"));
						Параметр.Значение = ГоризонтальноеПоложение.Центр;
						Параметр.Использование = Истина;

					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;

	КонецЦикла;

	//Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);

	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	//Основной цикл вывода отчета
	Пока Истина Цикл
		//Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();

		Если ЭлементРезультата = Неопределено Тогда
			//Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				  И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				  И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда

				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;

			КонецЕсли;
			//Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;

	ПроцессорВывода.ЗакончитьВывод();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗаголовкиПолей()
	
	Если НЕ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	ВалютаУправленческогоУчета = Строка(Константы.ВалютаУправленческогоУчета.Получить());

	Для Каждого ПолеНабораДанных Из СхемаКомпоновкиДанных.НаборыДанных.ВыручкаИСебестоимостьПродаж.Поля Цикл
		Если ТипЗнч(ПолеНабораДанных) = Тип("ПолеНабораДанныхСхемыКомпоновкиДанных") Тогда
			Если СтрНайти(ПолеНабораДанных.Заголовок, "%ВалютаУпр%") > 0 Тогда
				ПолеНабораДанных.Заголовок = СтрЗаменить(ПолеНабораДанных.Заголовок, "%ВалютаУпр%", ВалютаУправленческогоУчета);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

УстановитьЗаголовкиПолей();

#КонецЕсли