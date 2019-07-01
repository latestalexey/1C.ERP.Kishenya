
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекущаяПозиция = 0;
	
	Элементы.Далее.Доступность = Ложь;
	Элементы.Назад.Доступность = Ложь;
	
	НастройкиПоиска = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("НастройкиПолнотекстовогоПоиска", "");
	Если НастройкиПоиска <> Неопределено Тогда
		Если НастройкиПоиска.Свойство("ИскатьВРазделах") Тогда
			ИскатьВРазделах = НастройкиПоиска.ИскатьВРазделах;
		КонецЕсли;
		ОбластиПоиска = НастройкиПоиска.ОбластиПоиска;
	КонецЕсли;
	
	Массив = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить("ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска", "");
	
	Если Массив <> Неопределено Тогда
		Элементы.СтрокаПоиска.СписокВыбора.ЗагрузитьЗначения(Массив);
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.ПереданнаяСтрокаПоиска) Тогда
		ИскатьВРазделах = Ложь;
		
		СтрокаПоиска = Параметры.ПереданнаяСтрокаПоиска;
		
		СохранитьСтрокуПоиска(Элементы.СтрокаПоиска.СписокВыбора, СтрокаПоиска);
		Попытка
			Результат = ВыполнитьПоискСервер(0, ТекущаяПозиция, СтрокаПоиска);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			Возврат;
		КонецПопытки;
		
		РезультатыПоиска = Результат.РезультатПоиска;
		HTMLТекст = Результат.HTMLТекст;
		ТекущаяПозиция = Результат.ТекущаяПозиция;
		ПолноеКоличество = Результат.ПолноеКоличество;
		
		Если РезультатыПоиска.Количество() <> 0 Тогда
			
			ПоказаныРезультатыСПо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='Показаны %1 - %2 из %3';uk='Показані %1 - %2 з %3'"),
				Строка(ТекущаяПозиция + 1),
				Строка(ТекущаяПозиция + РезультатыПоиска.Количество()),
				Строка(ПолноеКоличество) );
			
			Элементы.Далее.Доступность = (ПолноеКоличество - ТекущаяПозиция) > РезультатыПоиска.Количество();
			Элементы.Назад.Доступность = (ТекущаяПозиция > 0);
		Иначе
			ПоказаныРезультатыСПо = НСтр("ru='Не найдено';uk='Не знайдено'");
			Элементы.Далее.Доступность = Ложь;
			Элементы.Назад.Доступность = Ложь;
		КонецЕсли;
	Иначе
		HTMLТекст = 
		"<html>
		|<head>
		|<meta http-equiv=""Content-Style-Type"" content=""text/css"">
		|</head>
		|<body topmargin=0 leftmargin=0 scroll=auto>
		|<table border=""0"" width=""100%"" cellspacing=""5"">
		|</table>
		|</body>
		|</html>";
		СформироватьПредставлениеОбластиПоиска();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	СохранитьНастройкиПоиска();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтрокаПоискаПриИзменении(Элемент)
	
	Отказ = Ложь;
	
	Искать(0, Отказ);
	
	Если НЕ Отказ Тогда
		ТекущийЭлемент = Элементы.СтрокаПоиска;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтрокаПоискаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	// Для платформы
	#Если ВебКлиент Тогда
	Если Элементы.СтрокаПоиска.СписокВыбора.Количество() = 1 Тогда
		ВыбранноеЗначение = Элемент.ТекстРедактирования;
	КонецЕсли;
	#КонецЕсли
	СтрокаПоиска = ВыбранноеЗначение;
	Искать(0);
	
КонецПроцедуры

&НаКлиенте
Процедура HTMLТекстПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	ЭлементHTML = ДанныеСобытия.Anchor;
	
	Если ЭлементHTML = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ЭлементHTML.id = "FullTextSearchListItem") Тогда
		СтандартнаяОбработка = Ложь;
		
		ЧастьURL = ЭлементHTML.outerHTML;
		Позиция = СтрНайти(ЧастьURL, "sel_num=");
		ЧастьURLОбрезанная = Сред(ЧастьURL, Позиция + 9);
		ПозицияОкончание = СтрНайти(ЧастьURLОбрезанная, """");
		Если ПозицияОкончание = 0 Тогда
			ПозицияОкончание = СтрНайти(ЧастьURLОбрезанная, "'");
			Если ПозицияОкончание = 0 Тогда
				ПозицияОкончание = 2;
			КонецЕсли;
		КонецЕсли;
		Если Позиция <> 0 Тогда
			ЧастьURL = Сред(ЧастьURLОбрезанная, 1, ПозицияОкончание - 1);
		КонецЕсли;
			
		НомерВСписке = Число(ЧастьURL);
		СтруктураРезультата = РезультатыПоиска[НомерВСписке].Значение;
		ВыбраннаяСтрока = СтруктураРезультата.Значение;
		МассивОбъектов = СтруктураРезультата.ЗначенияДляОткрытия;
		
		Если МассивОбъектов.Количество() = 1 Тогда
			ОткрытьЗначениеПоиска(МассивОбъектов[0]);
		ИначеЕсли МассивОбъектов.Количество() <> 0 Тогда
			Список = Новый СписокЗначений;
			Для Каждого ЭлементМассива Из МассивОбъектов Цикл
				Список.Добавить(ЭлементМассива);
			КонецЦикла;
			
			Обработчик = Новый ОписаниеОповещения("HTMLТекстПриНажатииПослеВыбораИзСписка", ЭтотОбъект);
			ПоказатьВыборИзСписка(Обработчик, Список, Элементы.HTMLТекст);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбластиПоискаНажатие(Элемент)
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ОбластиПоиска", ОбластиПоиска);
	ПараметрыОткрытия.Вставить("ИскатьВРазделах", ИскатьВРазделах);
	
	ОписаниеОповещения = 
		Новый ОписаниеОповещения("ОбластиПоискаНажатиеПродолжение", ЭтотОбъект);
	
	ОткрытьФорму(
		"Обработка.ПолнотекстовыйПоискВДанных.Форма.Настройки",
		ПараметрыОткрытия,,,,,
		ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбластиПоискаНажатиеПродолжение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		ОбластиПоиска = Результат.ОбластиПоиска;
		ИскатьВРазделах = Результат.ИскатьВРазделах;
		СформироватьПредставлениеОбластиПоиска();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыполнитьПоиск(Команда)
	
	Искать(0);
	
КонецПроцедуры

&НаКлиенте
Процедура Следующие(Команда)
	
	Искать(1);
	
КонецПроцедуры

&НаКлиенте
Процедура Предыдущие(Команда)
	
	Искать(-1);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьЗначениеПоиска(Значение)
	
	ПоказатьЗначение(, Значение);

КонецПроцедуры

&НаКлиенте
Процедура Искать(Направление, Отказ = Неопределено)
	// Процедура поиска, получение и отображение результата.
	
	Если ПустаяСтрока(СтрокаПоиска) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Введите, что нужно найти.';uk='Введіть, що потрібно знайти.'"), , "СтрокаПоиска");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ЭтоНавигационнаяСсылка = СтрНайти(СтрокаПоиска, "e1cib/data/") <> 0;
	Если ЭтоНавигационнаяСсылка Тогда
		ПерейтиПоНавигационнойСсылке(СтрокаПоиска);
		СтрокаПоиска = "";
		Возврат;
	КонецЕсли;
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Выполняется поиск ""%1""...';uk='Виконується пошук ""%1""...'"), СтрокаПоиска));
	
	СписокВыбора = Элементы.СтрокаПоиска.СписокВыбора.Скопировать();
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ИскатьВРазделах", ИскатьВРазделах);
	ДополнительныеПараметры.Вставить("ОбластиПоиска", ОбластиПоиска);
	Результат = СохранитьСтрокуИВыполнитьПоискСервер(Направление, ТекущаяПозиция, СтрокаПоиска, СписокВыбора, ДополнительныеПараметры);
	Элементы.СтрокаПоиска.СписокВыбора.Очистить();
	Для Каждого ЭлементСпискаВыбора Из СписокВыбора Цикл
		Элементы.СтрокаПоиска.СписокВыбора.Добавить(ЭлементСпискаВыбора.Значение, ЭлементСпискаВыбора.Представление);
	КонецЦикла;
	
	РезультатыПоиска = Результат.РезультатПоиска;
	HTMLТекст = Результат.HTMLТекст;
	ТекущаяПозиция = Результат.ТекущаяПозиция;
	ПолноеКоличество = Результат.ПолноеКоличество;
	
	Если РезультатыПоиска.Количество() > 0 Тогда
		
		ПоказаныРезультатыСПо = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Показаны %1 - %2 из %3';uk='Показані %1 - %2 з %3'"),
			Формат(ТекущаяПозиция + 1, "ЧН=0; ЧГ="),
			Формат(ТекущаяПозиция + РезультатыПоиска.Количество(), "ЧН=0; ЧГ="),
			Формат(ПолноеКоличество, "ЧН=0; ЧГ="));
		
		Элементы.Далее.Доступность = (ПолноеКоличество - ТекущаяПозиция) > РезультатыПоиска.Количество();
		Элементы.Назад.Доступность = (ТекущаяПозиция > 0);
		
		Если Направление = 0 И Результат.ТекущаяПозиция = 0 И Результат.СлишкомМногоРезультатов Тогда
			ПоказатьПредупреждение(, НСтр("ru='Слишком много результатов, уточните запрос.';uk='Занадто багато результатів, уточніть запит.'"));
		КонецЕсли;
	
	Иначе
		
		ПоказаныРезультатыСПо = НСтр("ru='Не найдено';uk='Не знайдено'");
		
		Элементы.Далее.Доступность = Ложь;
		Элементы.Назад.Доступность = Ложь;
		
		ТекстПоиска = НСтр("ru='Искомая комбинация слов нигде не встречается.<br><br>
            |<b>Рекомендации:</b>
            |<li>Убедитесь, что все слова написаны без ошибок.
            |<li>Попробуйте использовать другие ключевые слова.
            |<li>Попробуйте уменьшить количество искомых слов.'
            |;uk='Шукана комбінація слів ніде не зустрічається.<br><br>
            |<b>Рекомендації:</b>
            |<li>Переконайтеся, що всі слова написані без помилок.
            |<li>Спробуйте використати інші ключові слова.
            |<li>Спробуйте зменшити кількість шуканих слів.'");
		
		HTMLТекст = 
		"<html>
		|<head>
		|<meta http-equiv=""Content-Style-Type"" content=""text/css"">
		|<style>H1 {
		|	TEXT-ALIGN: left; FONT-FAMILY: Arial, Tahoma; COLOR: #003366; FONT-SIZE: 18pt; FONT-WEIGHT: bold
		|}
		|.Programtext {
		|	FONT-FAMILY: Courier; COLOR: #000080; FONT-SIZE: 10pt
		|}
		|H3 {
		|	TEXT-ALIGN: left; FONT-FAMILY: Arial, Tahoma; FONT-SIZE: 11pt; FONT-WEIGHT: bold
		|}
		|H4 {
		|	TEXT-ALIGN: left; FONT-FAMILY: Arial, Tahoma; FONT-SIZE: 10pt; FONT-WEIGHT: bold
		|}
		|BODY {
		|	FONT-FAMILY: Verdana; FONT-SIZE: 8pt
		|}</style>
		|</head>
		|<body scroll=auto>
		|" + ТекстПоиска + "
		|</body>
		|</html>";
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗначенияДляОткрытия(Объект)
	// Возвращает массив объектов (возможно из одного элемента) для показа пользователю.
	Результат = Новый Массив;
	
	// Объект ссылочного типа
	Если ОбщегоНазначения.ЗначениеСсылочногоТипа(Объект) Тогда
		Результат.Добавить(Объект);
		Возврат Результат;
	КонецЕсли;
	
	МетаданныеОбъекта = Метаданные.НайтиПоТипу(ТипЗнч(Объект));
	ИмяМетаданного = МетаданныеОбъекта.Имя;
	
	ПолноеИмяОбъекта = ВРег(Метаданные.НайтиПоТипу(ТипЗнч(Объект)).ПолноеИмя());
	ЭтоРегистрСведений = (СтрНайти(ПолноеИмяОбъекта, "РЕГИСТРСВЕДЕНИЙ.") > 0);

	Если Не ЭтоРегистрСведений Тогда // Регистр бухгалтерии или накопления или расчета.
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;

	// Ниже - это уже регистр сведений.
	Если МетаданныеОбъекта.РежимЗаписи = Метаданные.СвойстваОбъектов.РежимЗаписиРегистра.ПодчинениеРегистратору Тогда
		Регистратор = Объект["Регистратор"];
		Результат.Добавить(Регистратор);
		Возврат Результат;
	КонецЕсли;

	// Независимый регистр сведений
	// сперва - основные типы.
	Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
		Если Измерение.Ведущее Тогда 
			ЗначениеИзмерения = Объект[Измерение.Имя];
			
			Если ОбщегоНазначения.ЗначениеСсылочногоТипа(ЗначениеИзмерения) Тогда
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
			
		КонецЕсли;
	КонецЦикла;

	Если Результат.Количество() = 0 Тогда
		// теперь - любые типы
		Для Каждого Измерение Из МетаданныеОбъекта.Измерения Цикл
			Если Измерение.Ведущее Тогда 
				ЗначениеИзмерения = Объект[Измерение.Имя];
				Результат.Добавить(ЗначениеИзмерения);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Нет ни одного ведущего измерения - вернем сам ключ регистра сведений.
	Если Результат.Количество() = 0 Тогда
		Результат.Добавить(Объект);
	КонецЕсли;

	Возврат Результат;
КонецФункции

&НаСервереБезКонтекста
Функция СохранитьСтрокуИВыполнитьПоискСервер(Направление, ТекущаяПозиция, СтрокаПоиска, СписокВыбора, ДополнительныеПараметры)
	// Процедура выполняет полнотекстовый поиск.
	
	СохранитьСтрокуПоиска(СписокВыбора, СтрокаПоиска);
	
	Возврат ВыполнитьПоискСервер(Направление, ТекущаяПозиция, СтрокаПоиска, ДополнительныеПараметры);
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьСтрокуПоиска(СписокВыбора, СтрокаПоиска)
	
	СохраненнаяСтрока = СписокВыбора.НайтиПоЗначению(СтрокаПоиска);
	
	Если СохраненнаяСтрока <> Неопределено Тогда
		СписокВыбора.Удалить(СохраненнаяСтрока);
	КонецЕсли;
		
	СписокВыбора.Вставить(0, СтрокаПоиска);
	
	КоличествоСтрок = СписокВыбора.Количество();
	
	Если КоличествоСтрок > 20 Тогда
		СписокВыбора.Удалить(КоличествоСтрок - 1);
	КонецЕсли;
	
	Строки = СписокВыбора.ВыгрузитьЗначения();
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ПолнотекстовыйПоискСтрокиПолнотекстовогоПоиска",
		"",
		Строки);
	
	КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиПоиска()
	
	Настройки = Новый Структура;
	Настройки.Вставить("ОбластиПоиска", ОбластиПоиска);
	Настройки.Вставить("ИскатьВРазделах", ИскатьВРазделах);
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("НастройкиПолнотекстовогоПоиска", "", Настройки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВыполнитьПоискСервер(Направление, ТекущаяПозиция, СтрокаПоиска, ДополнительныеПараметры = Неопределено)
	// Процедура выполняет полнотекстовый поиск.
	
	РазмерПорции = 20;
	
	СписокПоиска = ПолнотекстовыйПоиск.СоздатьСписок(СтрокаПоиска, РазмерПорции);
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		Если ДополнительныеПараметры.ИскатьВРазделах И ДополнительныеПараметры.ОбластиПоиска.Количество() > 0 Тогда
			СписокПоиска.ИспользованиеМетаданных = ИспользованиеМетаданныхПолнотекстовогоПоиска.НеИспользовать;
			ОбластьПоиска = Новый Массив;
			Для Каждого Область Из ДополнительныеПараметры.ОбластиПоиска Цикл
				ОбластьПоиска.Добавить(ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Область.Значение));
			КонецЦикла;
			СписокПоиска.ОбластьПоиска = ОбластьПоиска;
		КонецЕсли;
	КонецЕсли;

	Если Направление = 0 Тогда
		СписокПоиска.ПерваяЧасть();
	ИначеЕсли Направление = -1 Тогда
		СписокПоиска.ПредыдущаяЧасть(ТекущаяПозиция);
	ИначеЕсли Направление = 1 Тогда
		СписокПоиска.СледующаяЧасть(ТекущаяПозиция);
	КонецЕсли;
	
	РезультатыПоиска = Новый СписокЗначений;
	Для Каждого Результат Из СписокПоиска Цикл
		СтруктураРезультата = Новый Структура;
		СтруктураРезультата.Вставить("Значение", Результат.Значение);
		СтруктураРезультата.Вставить("ЗначенияДляОткрытия", ПолучитьЗначенияДляОткрытия(Результат.Значение));
		РезультатыПоиска.Добавить(СтруктураРезультата);
	КонецЦикла;
	
	HTMLТекст = СписокПоиска.ПолучитьОтображение(ВидОтображенияПолнотекстовогоПоиска.HTMLТекст);
	
	HTMLТекст = СтрЗаменить(HTMLТекст, "<td>", "<td><font face=""Arial"" size=""2"">");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<td valign=top width=1>", "<td valign=top width=1><font face=""Arial"" size=""1"">");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<body>", "<body topmargin=0 leftmargin=0 scroll=auto>");
	HTMLТекст = СтрЗаменить(HTMLТекст, "</td>", "</font></td>");
	HTMLТекст = СтрЗаменить(HTMLТекст, "<b>", "");
	HTMLТекст = СтрЗаменить(HTMLТекст, "</b>", "");
	HTMLТекст = СтрЗаменить(HTMLТекст, "overflow:auto", "");
	
	ТекущаяПозиция = СписокПоиска.НачальнаяПозиция();
	ПолноеКоличество = СписокПоиска.ПолноеКоличество();
	СлишкомМногоРезультатов = СписокПоиска.СлишкомМногоРезультатов();
	
	Результат = Новый Структура;
	Результат.Вставить("РезультатПоиска", РезультатыПоиска);
	Результат.Вставить("ТекущаяПозиция", ТекущаяПозиция);
	Результат.Вставить("ПолноеКоличество", ПолноеКоличество);
	Результат.Вставить("HTMLТекст", HTMLТекст);
	Результат.Вставить("СлишкомМногоРезультатов", СлишкомМногоРезультатов);
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура HTMLТекстПриНажатииПослеВыбораИзСписка(ВыбранныйЭлемент, ДополнительныеПараметры) Экспорт
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОткрытьЗначениеПоиска(ВыбранныйЭлемент.Значение);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьПредставлениеОбластиПоиска()
	
	Если Не ИскатьВРазделах Или ОбластиПоиска.Количество() = 0 Тогда
		Элементы.ОбластиПоискаПредставление.Заголовок = НСтр("ru='Везде';uk='Скрізь'");
		Возврат;
	КонецЕсли;
	
	ПредставлениеОбластиПоиска = "";
	Если ОбластиПоиска.Количество() < 4 Тогда
		Для Каждого Область Из ОбластиПоиска Цикл
			ОбъектМетаданных = ОбщегоНазначения.ОбъектМетаданныхПоИдентификатору(Область.Значение);
			ПредставлениеОбластиПоиска = ПредставлениеОбластиПоиска + ПредставлениеФормыСписка(ОбъектМетаданных) + ",";
		КонецЦикла;
		Элементы.ОбластиПоискаПредставление.Заголовок = Лев(ПредставлениеОбластиПоиска, СтрДлина(ПредставлениеОбластиПоиска)-1);
	Иначе
		Элементы.ОбластиПоискаПредставление.Заголовок = НСтр("ru='В выбранных разделах';uk='У вибраних розділах'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеФормыСписка(Объект)
	
	Если Не ПустаяСтрока(Объект.РасширенноеПредставлениеСписка) Тогда
		Представление = Объект.РасширенноеПредставлениеСписка;
	ИначеЕсли Не ПустаяСтрока(Объект.ПредставлениеСписка) Тогда
		Представление = Объект.ПредставлениеСписка;
	Иначе
		Представление = Объект.Представление();
	КонецЕсли;
	
	Возврат Представление;
	
КонецФункции

#КонецОбласти
