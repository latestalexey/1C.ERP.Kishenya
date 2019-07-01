&НаКлиенте
Перем ОбновитьИнтерфейс;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Значения реквизитов формы
	СоставНабораКонстантФормы    = ОбщегоНазначенияУТ.ПолучитьСтруктуруНабораКонстант(НаборКонстант);
	ВнешниеРодительскиеКонстанты = ОбщегоНазначенияУТПовтИсп.ПолучитьСтруктуруРодительскихКонстант(СоставНабораКонстантФормы);
	РежимРаботы 				 = ОбщегоНазначенияПовтИсп.РежимРаботыПрограммы();
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	РежимРаботы.Вставить("БазоваяВерсия", 				 ПолучитьФункциональнуюОпцию("БазоваяВерсия"));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	УстановитьПривилегированныйРежим(Истина);
	ПарольИЛогин = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(ИнтеграцияССППР.ВладелецЛогинаИПароля(), "Пароль, Логин");
	УстановитьПривилегированныйРежим(Ложь);
	ПользовательСППР = ПарольИЛогин.Логин;
	ПарольСППР = ?(ЗначениеЗаполнено(ПарольИЛогин.Пароль), ЭтотОбъект.УникальныйИдентификатор, "");
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия <> "Запись_НаборКонстант" Тогда
		Возврат; // такие событие не обрабатываются
	КонецЕсли;
	
	// Если это изменена константа, расположенная в другой форме и влияющая на значения констант этой формы,
	// то прочитаем значения констант и обновим элементы этой формы.
	Если РежимРаботы.ВнешниеРодительскиеКонстанты.Свойство(Источник)
	 ИЛИ (ТипЗнч(Параметр) = Тип("Структура")
	 		И ОбщегоНазначенияУТКлиентСервер.ПолучитьОбщиеКлючиСтруктур(
	 			Параметр, РежимРаботы.ВнешниеРодительскиеКонстанты).Количество() > 0) Тогда
		
		ЭтаФорма.Прочитать();
		УстановитьДоступность();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИспользоватьИнтеграциюССППРПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура АдресВебСервисаСППРПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользовательСППРПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольСППРПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектСППРПриИзменении(Элемент)
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектСППРНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ПустаяСтрока(НаборКонстант.АдресВебСервисаСППР) 
		ИЛИ ПустаяСтрока(ПользовательСППР) Тогда
		
		ТекстПредупреждения = НСтр("ru='Для выбора проекта нужно заполнить параметры соединения с базой СППР.
                                        |При успешном соединении можно выбрать проект из списка проектов базы СППР.
                                        |Если соединение недоступно, то имя проекта можно ввести вручную.'
                                        |;uk='Для вибору проекту потрібно заповнити параметри з''єднання з базою СППР.
                                        |При успішному з''єднанні можна вибрати проект зі списку проектів бази СППР.
                                        |Якщо з''єднання недоступне, то ім''я проекту можна ввести вручну.'");
  		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	СписокПроектов = СписокПроектовСППР();
	ОписаниеОповещения = Новый ОписаниеОповещения("ПроектСППРНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеОповещения, СписокПроектов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаПроверитьСоединение(Команда)
	
	Если ПустаяСтрока(НаборКонстант.АдресВебСервисаСППР) 
		ИЛИ ПустаяСтрока(ПользовательСППР) Тогда
		
		ТекстПредупреждения = НСтр("ru='Перед проверкой необходимо заполнить параметры:
                                        | - URL информационной базы СППР 
                                        | - имя пользователя'
                                        |;uk='Перед перевіркою необхідно заповнити параметри:
                                        |- URL інформаційної бази СППР 
                                        |- ім''я користувача'");
  		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	ПроверитьСоединение();
	ПоказатьПредупреждение(, НСтр("ru='Соединение успешно установлено.';uk='З''єднання успішно встановлено.'"),, НСтр("ru='Проверка соединения с СППР';uk='Перевірка з''єднання з СППР'"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	Результат = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	Если ОбновлятьИнтерфейс Тогда
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 1, Истина);
		ОбновитьИнтерфейс = Истина;
	КонецЕсли;
	
	СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтаФорма, Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроектСППРНачалоВыбораЗавершение(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйЭлемент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НаборКонстант.ПроектСППР = ВыбранныйЭлемент.Значение;
	
	Подключаемый_ПриИзмененииРеквизита(Элементы.ПроектСППР);
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	Результат = Новый Структура;
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ПроверитьСоединение()

	ПроксиВебСервиса = ИнтеграцияССППР.ПолучитьПрокси();
	
КонецПроцедуры

&НаСервере
Функция СписокПроектовСППР()

	ВебСервис = ИнтеграцияССППР.ПолучитьПрокси();
	СписокПроектов = ВебСервис.GetListOfProjects();
	
	Результат = Новый СписокЗначений;
	Для каждого ЭлементКоллекции Из СписокПроектов.Project Цикл
		Результат.Добавить(ЭлементКоллекции.Name);
	КонецЦикла; 

	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Процедура СохранитьЗначениеРеквизита(РеквизитПутьКДанным, Результат)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат;
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
	КонецЕсли;
	
	// Сохранения значения константы.
	Если КонстантаИмя <> "" Тогда
		КонстантаМенеджер = Константы[КонстантаИмя];
		КонстантаЗначение = НаборКонстант[КонстантаИмя];
		
		Если КонстантаМенеджер.Получить() <> КонстантаЗначение Тогда
			КонстантаМенеджер.Установить(КонстантаЗначение);
		КонецЕсли;
		
		Если ОбщегоНазначенияУТПовтИсп.ЕстьПодчиненныеКонстанты(КонстантаИмя, КонстантаЗначение) Тогда
			ЭтаФорма.Прочитать();
		КонецЕсли;
		
	ИначеЕсли РеквизитПутьКДанным = "ПользовательСППР" Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ИнтеграцияССППР.ВладелецЛогинаИПароля(), ПользовательСППР, "Логин");
		УстановитьПривилегированныйРежим(Ложь);
	ИначеЕсли РеквизитПутьКДанным = "ПарольСППР" Тогда
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(ИнтеграцияССППР.ВладелецЛогинаИПароля(), ПарольСППР, "Пароль");
		УстановитьПривилегированныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьИнтеграциюССППР" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьИнтеграциюССППР;
		
		Элементы.АдресВебСервисаСППР.Доступность = ЗначениеКонстанты;
		Элементы.ПользовательСППР.Доступность = ЗначениеКонстанты;
		Элементы.ПарольСППР.Доступность = ЗначениеКонстанты;
		Элементы.ПроектСППР.Доступность	= ЗначениеКонстанты;
		Элементы.ПроверитьСоединение.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
