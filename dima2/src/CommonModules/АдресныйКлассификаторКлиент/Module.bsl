////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Подсистема "Адресный классификатор".
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Проверяет наличие обновлений адресного классификатора на сайте
// для тех субъектов, которые ранее уже загружались.
//
// Параметры:
//     ПараметрыВыполнения - ПараметрыВыполненияКоманды, Структура - параметры открытия формы.
//
Процедура ОпределитьНеобходимостьОбновленияАдресныхОбъектов(ПараметрыВыполнения = Неопределено) Экспорт
	
	СтруктураПараметров = Новый Структура("Источник");
	
	Если ПараметрыВыполнения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, ПараметрыВыполнения);
	КонецЕсли;
	
	Владелец = СтруктураПараметров.Источник;
		
	Если Не ЗапрашиватьДоступПриИспользовании() Тогда
		// Разрешения уже получены на всю конфигурацию.
		ПараметрыФормы = Новый Структура("Режим", "ПроверкаОбновления");
		ОткрытьФормуЗагрузкиАдресногоКлассификатора(ПараметрыВыполнения, ПараметрыФормы);
		Возврат;
	КонецЕсли;
		
	// Нужен запрос профиля безопасности.
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПолучениеРазрешенияБезопасностиПроверкиНаличияОбновленияАдресныхОбъектов",
		ЭтотОбъект, ПараметрыВыполнения);
	
	РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
		АдресныйКлассификаторВызовСервера.ЗапросРазрешенийБезопасностиОбновления(),
		Владелец, ОписаниеОповещения);
	
КонецПроцедуры

// Открывает форму загрузки классификатора.
//
// Параметры:
//     Параметры - ПараметрыВыполненияКоманды, Структура - параметры открытия формы.
//
Процедура ЗагрузитьАдресныйКлассификатор(Параметры = Неопределено) Экспорт
	Возврат;
	
КонецПроцедуры

// Проверяет наличие обновлений адресного классификатора на сайте
// для тех субъектов, которые ранее уже загружались.
//
// Параметры:
//     ПараметрыВыполнения - ПараметрыВыполненияКоманды, Структура - параметры открытия формы.
//
Процедура ОткрытьФормуЗагрузкиАдресногоКлассификатора(ПараметрыФормы, ПараметрыВыполнения, ОповещениеОЗакрытие = Неопределено) Экспорт
	Возврат;
	
КонецПроцедуры

// Устарела. Следует использовать ОткрытьФормуЗагрузкиАдресногоКлассификатора.
// Проверяет наличие обновлений адресного классификатора на сайте
// для тех субъектов, которые ранее уже загружались.
//
// Параметры:
//     ПараметрыВыполнения - ПараметрыВыполненияКоманды, Структура - параметры открытия формы.
//
Процедура ОткрытьФормуПроверкиОбновления(ПараметрыВыполнения) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Режим", "ПроверкаОбновления");
	ОткрытьФормуЗагрузкиАдресногоКлассификатора(ПараметрыФормы, ПараметрыВыполнения);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Вызывает диалог выбора каталога.
// 
// Параметры:
//     Форма - УправляемаяФорма - вызывающий объект.
//     ПутьКДанным          - Строка             - полное имя реквизита формы, содержащего текущее значение каталога.
//                                                 Например.
//                                                "РабочийКаталог" или "Объект.КаталогИзображений".
//     Заголовок            - Строка             - Заголовок для диалога.
//     СтандартнаяОбработка - Булево             - для использования в обработчике "ПриНачалаВыбора". Будет заполнено
//                                                 значением Ложь.
//     ОповещениеЗавершения - ОписаниеОповещения - вызывается после успешного помещения нового значения в реквизит.
//
Процедура ВыбратьКаталог(Знач Форма, Знач ПутьКДанным, Знач Заголовок = Неопределено, СтандартнаяОбработка = Ложь, ОповещениеЗавершения = Неопределено) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	ОповещениеПродолжения = Новый ОписаниеОповещения("ВыбратьКаталогЗавершениеКонтроляРасширенияРаботыСФайлами", ЭтотОбъект, Новый Структура);
	ОповещениеПродолжения.ДополнительныеПараметры.Вставить("Форма",       Форма);
	ОповещениеПродолжения.ДополнительныеПараметры.Вставить("ПутьКДанным", ПутьКДанным);
	ОповещениеПродолжения.ДополнительныеПараметры.Вставить("Заголовок",   Заголовок);
	
	ОповещениеПродолжения.ДополнительныеПараметры.Вставить("ОповещениеЗавершения",   ОповещениеЗавершения);
	
	ОбщегоНазначенияКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(ОповещениеПродолжения, , Ложь);
КонецПроцедуры

// Завершение немодального выбора каталога.
//
Процедура ВыбратьКаталогЗавершениеКонтроляРасширенияРаботыСФайлами(Знач Результат, Знач ДополнительныеПараметры) Экспорт
	
	Если Результат <> Истина Тогда
		// Отказ от установки расширения.
		Возврат;
	КонецЕсли;
	
	Форма       = ДополнительныеПараметры.Форма;
	ПутьКДанным = ДополнительныеПараметры.ПутьКДанным;
	Заголовок   = ДополнительныеПараметры.Заголовок;
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Заголовок <> Неопределено Тогда
		Диалог.Заголовок = Заголовок;
	КонецЕсли;
	
	ВладелецЗначения = Форма;
	ТекущееЗначение  = Форма;
	ИмяРеквизита     = ПутьКДанным;
	
	ЧастиПути = СтрЗаменить(ПутьКДанным, ".", Символы.ПС);
	Для Позиция = 1 По СтрЧислоСтрок(ЧастиПути) Цикл
		ИмяРеквизита     = СтрПолучитьСтроку(ЧастиПути, Позиция);
		ВладелецЗначения = ТекущееЗначение;
		ТекущееЗначение  = ТекущееЗначение[ИмяРеквизита];
	КонецЦикла;
	
	Диалог.Каталог = ТекущееЗначение;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьКаталогЗавершениеОтображенияДиалогаВыбораФайла", ЭтотОбъект, ДополнительныеПараметры);
	Диалог.Показать(ОписаниеОповещения);
	
КонецПроцедуры

// Завершение модального получения подтверждения о получении ресурсов на проверку наличия обновления классификатора.
//
Процедура ПолучениеРазрешенияБезопасностиПроверкиНаличияОбновленияАдресныхОбъектов(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> КодВозвратаДиалога.ОК Тогда
		// Нет разрешения
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура("Режим", "ПроверкаОбновления");
	ОткрытьФормуЗагрузкиАдресногоКлассификатора(ДополнительныеПараметры, ПараметрыФормы);
КонецПроцедуры

Функция ЗапрашиватьДоступПриИспользовании()
	
	Возврат Ложь;
	
КонецФункции

Процедура ВыбратьКаталогЗавершениеОтображенияДиалогаВыбораФайла(Каталог, ДополнительныеПараметры) Экспорт
	
	Если Каталог <> Неопределено Тогда
		
		ДополнительныеПараметры.Форма[ДополнительныеПараметры.ПутьКДанным] = Каталог[0];
		
		Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, Каталог[0]);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Проверка на доступность всех необходимых файлов для загрузки.
//
// Параметры:
//     КодыРегионов      - Массив    - содержит числовые значения - коды регионов-субъектов РФ (для последующей
//                                     загрузки).
//     Каталог           - Строка    - каталог с проверяемыми файлами.
//     ПараметрыЗагрузки - Структура - содержит поля.
//         * КодИсточникаЗагрузки - Строка - описывает набор анализируемых файлов. Возможные значения: "КАТАЛОГ",
//                                           "САЙТ, "ИТС".
//         * ПолеОшибки           - Строка - имя реквизита для привязки сообщений об ошибке.
//
// Возвращаемое значение: 
//     Структура - описание результата. Содержит поля.
//         * КодыРегионов    - Массив -       содержит числовые значения кодов регионов-субъектов для которых доступны
//                                      все файлы.
//         * ЕстьВсеФайлы    - Булево       - флаг того, что можно загружать все регионы.
//         * Ошибки          - Структура    - см. описание ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю.
//         * ФайлыПоРегионам - Соответствие - соответствие файлов регионам. Ключ может быть:
//                                          - числом (код региона), тогда значение - массив имен файлов, необходимых
//                                          для загрузки этого региона
//                                          - символом "*", тогда значение - массив имен файлов, необходимых для
//                                          загрузки всех регионов.
//
Процедура АнализДоступностиФайловКлассификатораВКаталоге(ОписаниеЗавершения, КодыРегионов, Каталог, ПараметрыЗагрузки) Экспорт
	
	РабочийКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(Каталог);
	ПолеОшибки = ПараметрыЗагрузки.ПолеОшибки;
	
	Результат = Новый Структура;
	Результат.Вставить("КодыРегионов",    КодыРегионов);
	Результат.Вставить("ЕстьВсеФайлы",    Истина);
	Результат.Вставить("Ошибки",          Неопределено);
	Результат.Вставить("ФайлыПоРегионам", Новый Соответствие);
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОтсутствующиеФайлы", Новый Соответствие);
	ДополнительныеПараметры.Вставить("ОписаниеЗавершения", ОписаниеЗавершения);
	ДополнительныеПараметры.Вставить("Результат", Результат);
	ДополнительныеПараметры.Вставить("РабочийКаталог", РабочийКаталог);
	ДополнительныеПараметры.Вставить("ПолеОшибки", ПолеОшибки);
	ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ВыполнитьОбработкуОповещения(ОписаниеОповещения, 0);
	
КонецПроцедуры

Процедура АнализДоступностиФайловКлассификатораВКаталогеЗавершение(ИндексРегиона, ДополнительныеПараметры) Экспорт
	
	Если ИндексРегиона <= ДополнительныеПараметры.Результат.КодыРегионов.ВГраница() Тогда
		
		КодРегиона = ДополнительныеПараметры.Результат.КодыРегионов[ИндексРегиона];
		// Набор файлов для каждого региона.
		ДополнительныеПараметры.Результат.ФайлыПоРегионам[КодРегиона] = Новый Массив;
		
		ИмяФайла = Формат(КодРегиона, "ЧЦ=2; ЧН=; ЧВН=; ЧГ=") + ".ZIP";
		ДополнительныеПараметры.Вставить("КодРегиона", КодРегиона);
		ДополнительныеПараметры.Вставить("ИмяФайла", ИмяФайла);
		ДополнительныеПараметры.Вставить("ИндексРегиона", ИндексРегиона);
		ОписаниеОповещения = Новый ОписаниеОповещения("АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов", ЭтотОбъект, ДополнительныеПараметры);
		НачатьПоискФайлов(ОписаниеОповещения, ДополнительныеПараметры.РабочийКаталог, МаскаФайла(ИмяФайла));
		
	Иначе // окончание цикла
		
		// Собираем все в один вызов
		Представления = АдресныйКлассификаторВызовСервера.ПредставлениеРегионаПоКоду(ДополнительныеПараметры.ОтсутствующиеФайлы);
		
		Для Каждого КлючЗначение Из Представления Цикл
			СообщениеОбОшибке = НСтр("ru='Для региона ""%1"" не найден файл данных ""%2""';uk='Для регіону ""%1"" не знайдено файл даних ""%2""'") + Символы.ПС;
			СообщениеОбОшибке = СообщениеОбОшибке + НСтр("ru='Актуальные адресные сведения можно загрузить по адресу http://its.1c.ru/download/fias';uk='Актуальні адресні відомості можна знайти за адресою http://its.1c.ru/download/fias'");
			
			ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(ДополнительныеПараметры.Результат.Ошибки, ДополнительныеПараметры.ПолеОшибки,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СообщениеОбОшибке, КлючЗначение.Значение, ДополнительныеПараметры.ОтсутствующиеФайлы[КлючЗначение.Ключ]), Неопределено);
		КонецЦикла;
		
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеЗавершения, ДополнительныеПараметры.Результат);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура АнализДоступностиФайловКлассификатораВКаталогеПослеПоискаФайлов(НайденныеФайлы, ДополнительныеПараметры) Экспорт
	
	СтруктураФайла = Новый Структура("Существует, Имя, ИмяБезРасширения, ПолноеИмя, Путь, Расширение", Ложь);
	Если НайденныеФайлы.Количество() > 0 Тогда
		
		СтруктураФайла.Существует = Истина;
		ЗаполнитьЗначенияСвойств(СтруктураФайла, НайденныеФайлы[0]);
	КонецЕсли;
	
	Если СтруктураФайла.Существует Тогда
		ДополнительныеПараметры.Результат.ФайлыПоРегионам[ДополнительныеПараметры.КодРегиона].Добавить(СтруктураФайла.ПолноеИмя);
	Иначе
		ДополнительныеПараметры.Результат.ЕстьВсеФайлы = Ложь;
		ДополнительныеПараметры.ОтсутствующиеФайлы.Вставить(ДополнительныеПараметры.КодРегиона, ДополнительныеПараметры.ИмяФайла);
	КонецЕсли;
	
	АнализДоступностиФайловКлассификатораВКаталогеЗавершение(ДополнительныеПараметры.ИндексРегиона + 1, ДополнительныеПараметры);
	
КонецПроцедуры

Функция МаскаФайла(ИмяФайла)
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Платформа = СистемнаяИнформация.ТипПлатформы;
	
	НеУчитыватьРегистр = Платформа = ТипПлатформы.Windows_x86 Или Платформа = ТипПлатформы.Windows_x86_64;
	
	Если НеУчитыватьРегистр Тогда
		Маска = ВРег(ИмяФайла);
	Иначе
		Маска = "";
		Для Позиция = 1 По СтрДлина(ИмяФайла) Цикл
			Символ = Сред(ИмяФайла, Позиция, 1);
			ВерхнийРегистр = ВРег(Символ);
			НижнийРегистр  = НРег(Символ);
			Если ВерхнийРегистр = НижнийРегистр Тогда
				Маска = Маска + Символ;
			Иначе
				Маска = Маска + "[" + ВерхнийРегистр + НижнийРегистр + "]";
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Маска;
	
КонецФункции

#КонецОбласти