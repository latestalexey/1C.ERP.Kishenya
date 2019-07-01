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
	
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьСделкиСКлиентами");
	ВнешниеРодительскиеКонстанты.Вставить("ИспользоватьПроизводство");
	
	РежимРаботы.Вставить("СоставНабораКонстантФормы",    Новый ФиксированнаяСтруктура(СоставНабораКонстантФормы));
	РежимРаботы.Вставить("ВнешниеРодительскиеКонстанты", Новый ФиксированнаяСтруктура(ВнешниеРодительскиеКонстанты));
	
	РежимРаботы = Новый ФиксированнаяСтруктура(РежимРаботы);
	
	ПереоцениватьВалютныеСредстваПоДням = НаборКонстант.ПереоцениватьВалютныеСредстваПоДням;
	
	Если НаборКонстант.ВидКонтроляТоваровОрганизаций = Перечисления.ВидыКонтроляТоваровОрганизаций.КонецДняКонецМесяцаИДатаПоследнегоДвижения Тогда
		КонтролироватьОстаткиТоваровОрганизацийНаКонецДня = Истина;
	Иначе
		КонтролироватьОстаткиТоваровОрганизацийНаКонецДня = Ложь;
	КонецЕсли;
	
	// Обновление состояния элементов
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОбновитьИнтерфейсПрограммы();
КонецПроцедуры

&НаКлиенте
// Обработчик оповещения формы.
//
// Параметры:
//	ИмяСобытия - Строка - обрабатывается только событие Запись_НаборКонстант, генерируемое панелями администрирования.
//	Параметр   - Структура - содержит имена констант, подчиненных измененной константе, "вызвавшей" оповещение.
//	Источник   - Строка - имя измененной константы, "вызвавшей" оповещение.
//
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
Процедура ИспользоватьНесколькоОрганизацийПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПодразделенияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаУправленческогоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ВалютаРегламентированногоУчетаПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьУправленческуюОрганизациюПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОбособленныеПодразделенияВыделенныеНаБалансПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПередачиТоваровМеждуОрганизациямиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьОстаткиТоваровОрганизацийПриИзменении(Элемент)
	Если Не НаборКонстант.КонтролироватьОстаткиТоваровОрганизаций Тогда
		КонтролироватьОстаткиТоваровОрганизацийНаКонецДня = Ложь;
	КонецЕсли;
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьОстаткиТоваровОрганизацийНаКонецДняПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КонтролироватьТоварыОрганизацийПриОтменеПриходовПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент, Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ОсновнойКалендарьПредприятияПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоВалютПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПереоцениватьВалютныеСредстваПоДнямПриИзменении(Элемент)
	
	НаборКонстант.ПереоцениватьВалютныеСредстваПоДням = ПереоцениватьВалютныеСредстваПоДням;
	
	Подключаемый_ПриИзмененииРеквизита(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьНесколькоКлассификацийЗадолженностиПриИзменении(Элемент)
	Подключаемый_ПриИзмененииРеквизита(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьПроизводственныеКалендари(Команда)
	ОткрытьФорму("Справочник.ПроизводственныеКалендари.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВалюты(Команда)
	ОткрытьФорму("Справочник.Валюты.ФормаСписка", , ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыВалюты(Команда)
	ОткрытьФорму("Справочник.Валюты.ФормаОбъекта",
		Новый Структура("Ключ", ПолучитьВалютуРегламентированногоУчета()));
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВариантыКлассификацииЗадолженности(Команда)
	
	ОткрытьФорму("Справочник.ВариантыКлассификацииЗадолженности.ФормаСписка", , ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСвойстваКлассификацииЗадолженности(Команда)
	
	ОткрытьФорму("Справочник.ВариантыКлассификацииЗадолженности.ФормаОбъекта",
		Новый Структура("Ключ",ЭлементПоУмолчаниюВызовСервера()),
		ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Клиент

&НаКлиенте
Процедура Подключаемый_ПриИзмененииРеквизита(Элемент, ОбновлятьИнтерфейс = Истина)
	
	КонстантаИмя = ПриИзмененииРеквизитаСервер(Элемент.Имя);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Если ОбновлятьИнтерфейс Тогда
		ОбновитьИнтерфейс = Истина;
		ПодключитьОбработчикОжидания("ОбновитьИнтерфейсПрограммы", 2, Истина);
	КонецЕсли;
	
	Если КонстантаИмя <> "" Тогда
		Оповестить("Запись_НаборКонстант", Новый Структура, КонстантаИмя);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнтерфейсПрограммы()
	
	Если ОбновитьИнтерфейс = Истина Тогда
		ОбновитьИнтерфейс = Ложь;
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВызовСервера

&НаСервере
Функция ПриИзмененииРеквизитаСервер(ИмяЭлемента)
	
	РеквизитПутьКДанным = Элементы[ИмяЭлемента].ПутьКДанным;
	
	КонстантаИмя = СохранитьЗначениеРеквизита(РеквизитПутьКДанным);
	
	УстановитьДоступность(РеквизитПутьКДанным);
	
	ОбновитьПовторноИспользуемыеЗначения();
	
	Возврат КонстантаИмя;
	
КонецФункции

#КонецОбласти

#Область Сервер

&НаСервере
Функция СохранитьЗначениеРеквизита(РеквизитПутьКДанным)
	
	// Сохранение значений реквизитов, не связанных с константами напрямую (в отношении один-к-одному).
	Если РеквизитПутьКДанным = "" Тогда
		Возврат "";
	КонецЕсли;
	
	// Определение имени константы.
	КонстантаИмя = "";
	Если НРег(Лев(РеквизитПутьКДанным, 14)) = НРег("НаборКонстант.") Тогда
		// Если путь к данным реквизита указан через "НаборКонстант".
		КонстантаИмя = Сред(РеквизитПутьКДанным, 15);
	Иначе
		
		// Определение имени и запись значения реквизита в соответствующей константе из "НаборКонстант".
		// Используется для тех реквизитов формы, которые связаны с константами напрямую (в отношении один-к-одному).
		Если РеквизитПутьКДанным = "ПереоцениватьВалютныеСредстваПоДням" Тогда
			КонстантаИмя = "ПереоцениватьВалютныеСредстваПоДням";
			НаборКонстант.ПереоцениватьВалютныеСредстваПоДням = Булево(ПереоцениватьВалютныеСредстваПоДням);
		КонецЕсли;
		
		Если РеквизитПутьКДанным = "КонтролироватьОстаткиТоваровОрганизацийНаКонецДня" Тогда
			КонстантаИмя = "ВидКонтроляТоваровОрганизаций";
			
			Если КонтролироватьОстаткиТоваровОрганизацийНаКонецДня Тогда
				НаборКонстант.ВидКонтроляТоваровОрганизаций = Перечисления.ВидыКонтроляТоваровОрганизаций.КонецДняКонецМесяцаИДатаПоследнегоДвижения;
			ИначеЕсли НаборКонстант.КонтролироватьОстаткиТоваровОрганизаций Тогда
				НаборКонстант.ВидКонтроляТоваровОрганизаций =Перечисления.ВидыКонтроляТоваровОрганизаций.КонецМесяцаИДатаПоследнегоДвижения;
			Иначе
				НаборКонстант.ВидКонтроляТоваровОрганизаций =Перечисления.ВидыКонтроляТоваровОрганизаций.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
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
		
	КонецЕсли;
	
	Возврат КонстантаИмя
	
КонецФункции

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РеквизитПутьКДанным = "НаборКонстант.ВалютаУправленческогоУчета" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВалютаУправленческогоУчета, ЗначениеЗаполнено(НаборКонстант.ВалютаУправленческогоУчета));
			
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ВалютаРегламентированногоУчета" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ВалютаРегламентированногоУчета, ЗначениеЗаполнено(НаборКонстант.ВалютаРегламентированногоУчета));
			
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоВалют" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоВалют;
		
		Если ЗначениеКонстанты Тогда
			Элементы.ГруппаСтраницыВалюты.ТекущаяСтраница = Элементы.ГруппаОткрытьВалюты;
		Иначе
			Элементы.ГруппаСтраницыВалюты.ТекущаяСтраница = Элементы.ГруппаПараметрыВалюты;
		КонецЕсли;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(
			Элементы.ИспользоватьНесколькоВалют, ЗначениеКонстанты);
		
		Элементы.ВалютаУправленческогоУчета.Доступность          = ЗначениеКонстанты;
		Элементы.ВалютаРегламентированногоУчета.Доступность      = ЗначениеКонстанты;
		Элементы.ПереоцениватьВалютныеСредстваПоДням.Доступность = ЗначениеКонстанты;
		
	КонецЕсли;
		
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоОрганизаций" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.ИспользоватьНесколькоОрганизаций;
		
		Если ЗначениеКонстанты Тогда
			Элементы.ГруппаСтраницыИспользоватьНесколькоОрганизаций.ТекущаяСтраница = Элементы.ГруппаНесколькоОрганизаций;
		Иначе
			Элементы.ГруппаСтраницыИспользоватьНесколькоОрганизаций.ТекущаяСтраница = Элементы.ГруппаОднаОрганизация;
		КонецЕсли;
		
		Элементы.ИспользоватьПередачиТоваровМеждуОрганизациями.Доступность           = ЗначениеКонстанты;
		Элементы.ИспользоватьУправленческуюОрганизацию.Доступность                   = ЗначениеКонстанты;
		Элементы.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс.Доступность = ЗначениеКонстанты и НаборКонстант.ИспользоватьПодразделения;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.КонтролироватьОстаткиТоваровОрганизаций" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		ЗначениеКонстанты = НаборКонстант.КонтролироватьОстаткиТоваровОрганизаций;
		
		Элементы.КонтролироватьТоварыОрганизацийПриОтменеПриходов.Доступность = ЗначениеКонстанты;
		Элементы.КонтролироватьОстаткиТоваровОрганизацийНаКонецДня.Доступность = ЗначениеКонстанты;
		
		Если КонтролироватьОстаткиТоваровОрганизацийНаКонецДня Тогда // при выключении константы скидываем флажок
			КонтролироватьОстаткиТоваровОрганизацийНаКонецДня = ЗначениеКонстанты;
		КонецЕсли;
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьПодразделения" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Элементы.ИспользоватьПодразделения.Доступность = Не НаборКонстант.ИспользоватьПроизводство;
		Элементы.ГруппаКомментарийИспользоватьПодразделения.Видимость = НаборКонстант.ИспользоватьПроизводство;
		
		ОбщегоНазначенияУТКлиентСервер.ОтображениеПредупрежденияПриРедактировании(Элементы.ИспользоватьПодразделения, НаборКонстант.ИспользоватьПодразделения);
		
	КонецЕсли;
	
	Если РеквизитПутьКДанным = "НаборКонстант.ИспользоватьНесколькоКлассификацийЗадолженности" ИЛИ РеквизитПутьКДанным = "" Тогда
		
		Если НаборКонстант.ИспользоватьНесколькоКлассификацийЗадолженности Тогда
			Элементы.ГруппаКлассификацияЗадолженностейПраво.ТекущаяСтраница = Элементы.ГруппаКлассификацияЗадолженностейПравоНесколькоВариантов;
		Иначе
			Элементы.ГруппаКлассификацияЗадолженностейПраво.ТекущаяСтраница = Элементы.ГруппаКлассификацияЗадолженностейПравоОдинВариант;
		КонецЕсли;

	КонецЕсли;
	
	ОбменДаннымиУТУП.УстановитьДоступностьНастроекУзлаИнформационнойБазы(ЭтаФорма);
	
	Если НЕ Константы.ИспользоватьНЕУКРОбъекты.Получить() Тогда
		Элементы.ГруппаПереоцениватьВалютныеСредстваПоДням.Видимость = Ложь;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область Прочие

&НаСервереБезКонтекста
Функция ПолучитьВалютуРегламентированногоУчета()
	Возврат Константы.ВалютаРегламентированногоУчета.Получить();
КонецФункции

&НаСервереБезКонтекста
Функция ЭлементПоУмолчаниюВызовСервера()
	Возврат Справочники.ВариантыКлассификацииЗадолженности.ЭлементПоУмолчанию();
КонецФункции

#КонецОбласти

#КонецОбласти
