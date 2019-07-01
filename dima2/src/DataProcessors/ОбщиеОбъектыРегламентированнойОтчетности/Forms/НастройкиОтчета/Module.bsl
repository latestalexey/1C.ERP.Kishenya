
// УстановитьФлажки()
//
&НаКлиенте
Процедура УстановитьФлажки(Команда)
			
	Если Элементы.Дерево.ТекущийЭлемент.Имя = "ДеревоВыгрузитьСтраницу" Тогда
		
		МассивНайденныхСтрок = Новый Массив;
		
		РегламентированнаяОтчетностьКлиент.НайтиСтрокиВДанныхФормыДерево(Дерево.ПолучитьЭлементы(), "ВыгрузитьСтраницу", 1, МассивНайденныхСтрок);
		
		Если МассивНайденныхСтрок.Количество() = Дерево.ПолучитьЭлементы().Количество() Тогда
			УстановитьПометкуСтрокДерева(2, Элементы.Дерево.ТекущийЭлемент.Имя);
		Иначе
			УстановитьПометкуСтрокДерева(1, Элементы.Дерево.ТекущийЭлемент.Имя);
		КонецЕсли;
		
	Иначе
		
		УстановитьПометкуСтрокДерева(1, Элементы.Дерево.ТекущийЭлемент.Имя);
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьФлажки()

// УстановитьПометкуСтрокДерева()
//
&НаКлиенте
Процедура УстановитьПометкуСтрокДерева(Пометка, Знач ТекКолонка)
	
	ТекКолонка = СтрЗаменить(ТекКолонка, "Дерево", "");

	Если ТекКолонка = "ПоказатьСтраницу" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.ПолучитьЭлементы() Цикл

			СтрокаУровня1[ТекКолонка] = Пометка;

			Если Пометка = 1 Тогда
				// Для составляющих страниц титульного листа 
				// запрещаем варирование показом страницы.
				// Флаг показа определяется только по титульному
				// листу в целом.
				Если СтрокаУровня1.ПолучитьЭлементы().Количество() > 0 Тогда
					НовПометка = 2;

					Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл

						СтрокаУровня2[ТекКолонка] = НовПометка;

						Если СтрокаУровня2.ПолучитьЭлементы().Количество() = 0 Тогда 
							Продолжить;
						КонецЕсли;

						Для Каждого СтрокаУровня3 Из СтрокаУровня2.ПолучитьЭлементы() Цикл
							СтрокаУровня3[ТекКолонка] = НовПометка;
						КонецЦикла;

					КонецЦикла;

					Продолжить;

				КонецЕсли; 

			ИначеЕсли Пометка = 0 Тогда
				// Предполагаем, что если пользователь отключил 
				// показ какой-либо страницы, то и необходимость
				// вывода этой страницы на печать отпадает
				СтрокаУровня1.ВыводНаПечать = Пометка;

				Для Каждого Строка Из СтрокаУровня1.ПолучитьЭлементы() Цикл
					Строка.ВыводНаПечать = Пометка;
				КонецЦикла;

			КонецЕсли;

			Если СтрокаУровня1.ПолучитьЭлементы().Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.ПолучитьЭлементы().Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.ПолучитьЭлементы() Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	ИначеЕсли  ТекКолонка = "ВыгрузитьСтраницу" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.ПолучитьЭлементы() Цикл

			СтрокаУровня1[ТекКолонка] = Пометка;

		КонецЦикла;

	ИначеЕсли ТекКолонка = "ВыводНаПечать" Тогда

		Для Каждого СтрокаУровня1 Из Дерево.ПолучитьЭлементы() Цикл

			СтрокаУровня1[ТекКолонка] = Пометка;

			Если СтрокаУровня1.ПолучитьЭлементы().Количество() = 0 Тогда 
				Продолжить;
			КонецЕсли;

			Для Каждого СтрокаУровня2 Из СтрокаУровня1.ПолучитьЭлементы() Цикл

				СтрокаУровня2[ТекКолонка] = Пометка;

				Если СтрокаУровня2.ПолучитьЭлементы().Количество() = 0 Тогда 
					Продолжить;
				КонецЕсли;

				Для Каждого СтрокаУровня3 Из СтрокаУровня2.ПолучитьЭлементы() Цикл
					СтрокаУровня3[ТекКолонка] = Пометка;
				КонецЦикла;

			КонецЦикла;
		КонецЦикла;

	Иначе
        					   
		ПоказатьПредупреждение(,СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Для установки или снятия меток по требуемой колонке%1предварительно активизируйте колонку.';uk='Для встановлення або зняття позначок за необхідною колонкою%1попередньо активізуйте колонку.'"), Символы.ПС));

	КонецЕсли;

КонецПроцедуры // УстановитьПометкуСтрокДерева()

// СнятьФлажки()
//
&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	УстановитьПометкуСтрокДерева(0, Элементы.Дерево.ТекущийЭлемент.Имя);
	
КонецПроцедуры // СнятьФлажки()

// ПроверитьТочность()
//
&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000)
	
	Если ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1 Тогда

		Если ТочностьЕдиницыИзмерения > 2 Тогда
			ТочностьЕдиницыИзмерения = 2;
		КонецЕсли;

	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000 Тогда

		Если ТочностьЕдиницыИзмерения > 3 Тогда
			ТочностьЕдиницыИзмерения = 3;
		КонецЕсли;

	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000000 Тогда

		Если ТочностьЕдиницыИзмерения > 6 Тогда
			ТочностьЕдиницыИзмерения = 6;
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры // ПроверитьТочность()

// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	мПараметры = Новый Структура;
	мПараметры.Вставить("ОтключитьАвтоРасчет", Истина);
	мПараметры.Вставить("Автосохранение", Истина);
	мПараметры.Вставить("ПараметрыОтображенияСумм", Истина);
	мПараметры.Вставить("Выгрузка", Ложь);

	Для Каждого ЭлементСтруктуры Из Параметры.мПараметры Цикл
		
		мПараметры.Вставить(ЭлементСтруктуры.Ключ, ЭлементСтруктуры.Значение);
		
	КонецЦикла;
	
	ПеречислениеПорядкиОкругленияОтчетностиОкр1       = Перечисления.ПорядкиОкругленияОтчетности.Окр1;
	ПеречислениеПорядкиОкругленияОтчетностиОкр1000    = Перечисления.ПорядкиОкругленияОтчетности.Окр1000;
	ПеречислениеПорядкиОкругленияОтчетностиОкр1000000 = Перечисления.ПорядкиОкругленияОтчетности.Окр1000000;
	
	// Список выбора поля выбора "Единица измерения"
	Элементы.ПредставлениеЕдиницыИзмерения.СписокВыбора.Добавить(НСтр("ru='в гривнях';uk='у гривнях'"));
	Элементы.ПредставлениеЕдиницыИзмерения.СписокВыбора.Добавить(НСтр("ru='в тысячах гривень';uk='у тисячах гривень'"));
	Элементы.ПредставлениеЕдиницыИзмерения.СписокВыбора.Добавить(НСтр("ru='в миллионах гривень';uk='у мільйонах гривень'"));
		
	Элементы.Дерево.ПодчиненныеЭлементы.ДеревоВыгрузитьСтраницу.Видимость = мПараметры.Выгрузка;
	
	Если мПараметры.ПараметрыОтображенияСумм И НЕ Параметры.ЕдиницаИзмерения = Неопределено Тогда
		Элементы.ЕдиницаИзмеренияИТочность.Видимость = Истина;
		ЕдиницаИзмерения = Параметры.ЕдиницаИзмерения;
		ТочностьЕдиницыИзмерения = Параметры.ТочностьЕдиницыИзмерения;
		ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000);
	Иначе
		Элементы.ЕдиницаИзмеренияИТочность.Видимость = Ложь;
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1;
		ТочностьЕдиницыИзмерения = 0;
	КонецЕсли;
		
	Если ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1 Тогда
		ПредставлениеЕдиницыИзмерения = НСтр("ru='в гривнях';uk='у гривнях'");
	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000 Тогда
		ПредставлениеЕдиницыИзмерения = НСтр("ru='в тысячах гривень';uk='у тисячах гривень'");
	ИначеЕсли ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000000 Тогда
		ПредставлениеЕдиницыИзмерения = НСтр("ru='в миллионах гривень';uk='у мільйонах гривень'");
	КонецЕсли;
			
	Если мПараметры.Автосохранение Тогда
		Элементы.Автосохранение.Видимость = Истина;
		ИнтервалАвтосохранения = Параметры.мИнтервалАвтосохранения;
		Если ИнтервалАвтосохранения = 0 Тогда
			ФлажокАвтосохранение = Ложь;
			Элементы.ИнтервалАвтосохранения.Доступность = Ложь;
		КонецЕсли;
		ФлажокАвтосохранение = (ИнтервалАвтосохранения <> 0);
		Если ИнтервалАвтосохранения = 0 Тогда
			ИнтервалАвтосохранения = 10;
		КонецЕсли;
	КонецЕсли;
	
	Если мПараметры.ОтключитьАвтоРасчет Тогда
		Элементы.ОтключитьАвтоматическийРасчет.Видимость = Истина;
		ОтключитьАвтоматическийРасчет = Параметры.ФлажокОтклАвтоРасчет;
	КонецЕсли;
	Если мПараметры.Свойство("СохранятьРасшифровкуАвтозаполнения") Тогда
		Элементы.СохранятьРасшифровкуАвтозаполнения.Видимость = Истина;
		СохранятьРасшифровкуАвтозаполнения = мПараметры.СохранятьРасшифровкуАвтозаполнения;
	КонецЕсли;
			
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ФлажокАвтосохранение", ФлажокАвтосохранение);
		
	УправлениеЭУ(СтруктураПараметров);

	
КонецПроцедуры // ПриСозданииНаСервере()

// УправлениеЭУ()
//
&НаКлиентеНаСервереБезКонтекста 
Процедура УправлениеЭУ(СтруктураПараметров)
	
	СтруктураПараметров.Элементы.ИнтервалАвтосохранения.Доступность = СтруктураПараметров.ФлажокАвтосохранение;
	СтруктураПараметров.Элементы.НадписьМинут.Доступность = СтруктураПараметров.ФлажокАвтосохранение;
	
КонецПроцедуры // УправлениеЭУ()

// ПриОткрытии()
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Элементы.Дерево.ТолькоПросмотр = (Дерево.ПолучитьЭлементы().Количество() = 1);
	Элементы.УстановитьСнятьФлажки.Доступность = (Дерево.ПолучитьЭлементы().Количество() > 1);
	
КонецПроцедуры // ПриОткрытии()

// ФлажокАвтосохранениеПриИзменении()
//
&НаКлиенте
Процедура ФлажокАвтосохранениеПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ФлажокАвтосохранение", ФлажокАвтосохранение);
		
	УправлениеЭУ(СтруктураПараметров);
	
КонецПроцедуры // ФлажокАвтосохранениеПриИзменении()

// РазрешитьВстроеннуюПечатьПриИзменении()
//
&НаКлиенте
Процедура РазрешитьВстроеннуюПечатьПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Элементы", Элементы);
	СтруктураПараметров.Вставить("ФлажокАвтосохранение", ФлажокАвтосохранение);
		
	УправлениеЭУ(СтруктураПараметров);
	
КонецПроцедуры // РазрешитьВстроеннуюПечатьПриИзменении()

// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть();
	
КонецПроцедуры // Сохранить()

// ДеревоПередНачаломДобавления()
//
&НаКлиенте
Процедура ДеревоПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
КонецПроцедуры // ДеревоПередНачаломДобавления()

// ДеревоПередУдалением()
//
&НаКлиенте
Процедура ДеревоПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	
КонецПроцедуры // ДеревоПередУдалением()

// ДеревоПередНачаломИзменения()
//
&НаКлиенте
Процедура ДеревоПередНачаломИзменения(Элемент, Отказ)
	
	ТекЭлемент  = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "Дерево", "");
	ТекЗначение = Элемент.ТекущиеДанные[ТекЭлемент];

	Если ТекЭлемент = "ПоказатьСтраницу" Тогда
		// Лист является составной частью титульного листа,
		// поэтому не меняем состояние флажка

		Если ТекЗначение = 2 Тогда

			Отказ = Истина;

		ИначеЕсли ТекЗначение = 0 Тогда
			Если Элемент.ТекущиеДанные.ПолучитьРодителя() <> Неопределено Тогда

				Отказ = Истина;

			КонецЕсли; 
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры // ДеревоПередНачаломИзменения()

// ПриИзмененииФлажка()
//
&НаКлиенте
Процедура ПриИзмененииФлажка(Элемент)
	
	ТекЭлемент = СтрЗаменить(Элемент.ТекущийЭлемент.Имя, "Дерево", "");
	
	НоваяПометка = Элемент.ТекущиеДанные[ТекЭлемент];

	Если ТекЭлемент = "ПоказатьСтраницу" Тогда
		Если НоваяПометка = 1 Тогда

			// Для составляющих страниц титульного листа 
			// запрещаем варирование показом страницы.
			// Флаг показа определяется только по титульному
			// листу в целом.
			НоваяПометка = 2;

		ИначеЕсли НоваяПометка = 0 Тогда
			// Предполагаем, что если пользователь отключил 
			// показ какой-либо страницы, то и необходимость
			// вывода этой страницы на печать отпадает
			Элемент.ТекущиеДанные.ВыводНаПечать = НоваяПометка;

			Для Каждого Строка Из Элемент.ТекущиеДанные.ПолучитьЭлементы() Цикл
				Строка.ВыводНаПечать = НоваяПометка;
			КонецЦикла;

		КонецЕсли;

	ИначеЕсли ТекЭлемент = "ВыводНаПечать" Тогда

		ВерхняяГруппировка = Элемент.ТекущиеДанные.ПолучитьРодителя();
		Если ВерхняяГруппировка <> Неопределено Тогда
			// Проверяем все вложенные строки на предмет
			// того, установлены или сняты ли везде метки.
			// Если нет, то устанавливаем третье состояние
			// метки строки-родителя 
			НеВсеОтмечены = 0;

			Для каждого СтрокаУровня Из ВерхняяГруппировка.ПолучитьЭлементы() Цикл

				Если СтрокаУровня.ВыводНаПечать <> НоваяПометка Тогда

					НеВсеОтмечены = 1;

					Прервать;
				КонецЕсли; 

			КонецЦикла; 

			Если НеВсеОтмечены = 1 Тогда
				ВерхняяГруппировка.ВыводНаПечать = 2;
			Иначе
				ВерхняяГруппировка.ВыводНаПечать = НоваяПометка;
			КонецЕсли;

		КонецЕсли;

	ИначеЕсли ТекЭлемент = "ВыгрузитьСтраницу" Тогда
		
		Если НоваяПометка = 0 Тогда
			Элемент.ТекущиеДанные[ТекЭлемент] = 1;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПриИзмененииФлажка()

// ДеревоПриИзменении()
//
&НаКлиенте
Процедура ДеревоПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
	ПриИзмененииФлажка(Элемент);
	
КонецПроцедуры // ДеревоПриИзменении()

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		Отказ = Истина;
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);

	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		
		Возврат;
		
	Иначе
		
		Отказ = Истина;
		СохранитьДанные();

	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		СохранитьДанные();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанные()
	
	Если мПараметры.Автосохранение Тогда
		ИнтервалАвтосохранения = ?(ФлажокАвтосохранение, ИнтервалАвтосохранения, 0);
		ВладелецФормы.СтруктураРеквизитовФормы.мИнтервалАвтосохранения = ИнтервалАвтосохранения;
	КонецЕсли;
	
	Если мПараметры.ОтключитьАвтоРасчет Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ФлажокОтклАвтоРасчет = ОтключитьАвтоматическийРасчет;
	КонецЕсли;
	
	Если мПараметры.Свойство("СохранятьРасшифровкуАвтозаполнения") Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.мСохранятьРасшифровку = СохранятьРасшифровкуАвтозаполнения;
	КонецЕсли;
	
	Если мПараметры.ПараметрыОтображенияСумм И Элементы.ЕдиницаИзмеренияИТочность.Видимость Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.ЕдиницаИзмерения = ЕдиницаИзмерения;
		ВладелецФормы.СтруктураРеквизитовФормы.ТочностьЕдиницыИзмерения = ТочностьЕдиницыИзмерения;
	КонецЕсли;
	
	мПрограммноеЗакрытие = Истина;
	Закрыть(Дерево);
	
КонецПроцедуры // ПередЗакрытием()

// ИнтервалАвтосохраненияПриИзменении()
//
&НаКлиенте
Процедура ИнтервалАвтосохраненияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры // ИнтервалАвтосохраненияПриИзменении()

// ТочностьЕдиницыИзмеренияПриИзменении()
//
&НаКлиенте
Процедура ТочностьЕдиницыИзмеренияПриИзменении(Элемент)
	
	ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000);
	
	Модифицированность = Истина;
	
КонецПроцедуры // ТочностьЕдиницыИзмеренияПриИзменении()

// ПредставлениеЕдиницыИзмеренияПриИзменении()
//
&НаКлиенте
Процедура ПредставлениеЕдиницыИзмеренияПриИзменении(Элемент)
	
	Если    ПредставлениеЕдиницыИзмерения = "в гривнях" ИЛИ ПредставлениеЕдиницыИзмерения = "у гривнях" Тогда
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1;
	ИначеЕсли ПредставлениеЕдиницыИзмерения = "в тысячах гривень"  ИЛИ ПредставлениеЕдиницыИзмерения = "у тисячах гривень" Тогда
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000;
	ИначеЕсли ПредставлениеЕдиницыИзмерения = "в миллионах гривень" ИЛИ ПредставлениеЕдиницыИзмерения = "у мільйонах гривень" Тогда
		ЕдиницаИзмерения = ПеречислениеПорядкиОкругленияОтчетностиОкр1000000;
	КонецЕсли;
	
	ПроверитьТочность(ЕдиницаИзмерения, ТочностьЕдиницыИзмерения, ПеречислениеПорядкиОкругленияОтчетностиОкр1, ПеречислениеПорядкиОкругленияОтчетностиОкр1000, ПеречислениеПорядкиОкругленияОтчетностиОкр1000000);
	
	ТочностьЕдиницыИзмерения = 0;
	
	Модифицированность = Истина;
	
КонецПроцедуры // ПредставлениеЕдиницыИзмеренияПриИзменении()

&НаКлиенте
Процедура СохранятьРасшифровкуАвтозаполненияПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьАвтоматическийРасчетПриИзменении(Элемент)
	
	Модифицированность = Истина;
	
КонецПроцедуры
