
#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

// Формирует структуру параметров открытия формы подбора товарав, свойственных подсистеме самооблуживание.
//
// Параметры
//  ПараметрыФормы  - Структура - параметры вызывающей формы
// Возвращаемое значение:
//   Структура   - сформированая структура параметров
//
Функция СтруктураПараметровДляПодбора(Параметры) Экспорт

	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗаголовокКнопкиПеренести",                   Параметры.ЗаголовокПеренести);
	ПараметрыФормы.Вставить("Соглашение",                                 Параметры.Соглашение);
	ПараметрыФормы.Вставить("Склад",                                      Параметры.Склад);
	ПараметрыФормы.Вставить("Валюта",                                     Параметры.Валюта);
	ПараметрыФормы.Вставить("Заголовок",                                  Параметры.Заголовок);
	ПараметрыФормы.Вставить("СегментНоменклатуры",                        Параметры.СегментНоменклатуры);
	ПараметрыФормы.Вставить("Документ",                                   Параметры.Документ);
	ПараметрыФормы.Вставить("ЦенаВключаетНДС",                            Параметры.ЦенаВключаетНДС);
	Если Параметры.ХозяйственнаяОперация = ПредопределенноеЗначение("Перечисление.ХозяйственныеОперации.ПередачаНаКомиссию") Тогда
		ПараметрыФормы.Вставить("ОтборПоТипуНоменклатуры", Новый ФиксированныйМассив(НоменклатураКлиентСервер.ОтборПоТоваруМногооборотнойТаре()));
	КонецЕсли;
	ПараметрыФормы.Вставить("ТолькоСЦенами",                              Истина);
	ПараметрыФормы.Вставить("СкрыватьКолонкуВидЦены",                     Истина);
	ПараметрыФормы.Вставить("СкрыватьКнопкуЗапрашиватьКоличество",        Ложь);
	ПараметрыФормы.Вставить("СкрыватьКомандуЦеныНоменклатуры",            Истина);
	ПараметрыФормы.Вставить("СкрыватьКомандуОстаткиНаСкладах",            Параметры.СкрыватьКомандуОстаткиНаСкладах);
	ПараметрыФормы.Вставить("ИспользоватьОтборПоИерархииНоменклатуры",    Истина);
	ПараметрыФормы.Вставить("СкрыватьНастройкуПодбора",                   Истина);
	ПараметрыФормы.Вставить("ИспользоватьОтборПоВидамНоменклатуры",       Истина);
	ПараметрыФормы.Вставить("НедоступностьФильтраПоСегментуНоменклатуры", Истина);
	ПараметрыФормы.Вставить("ПоказыватьПодобранныеТовары",                Истина);
	ПараметрыФормы.Вставить("СкрыватьВыборНоменклатуры",                  Истина);
	ПараметрыФормы.Вставить("СкрыватьРучныеСкидки",                       Истина);
	ПараметрыФормы.Вставить("Дата",                                       ТекущаяДата());
	ПараметрыФормы.Вставить("СкрыватьПодакцизныеТовары",                  Ложь);
	ПараметрыФормы.Вставить("ОтображатьФлагСкрыватьПодакцизныеТовары",    Ложь);
	ПараметрыФормы.Вставить("ЗапрашиватьКоличество",                      Ложь);
	ПараметрыФормы.Вставить("ЗапретРедактированияСоставаНабора",          Истина);
	ПараметрыФормы.Вставить("ЗапретРедактированияЦеныНабора",             Истина);
	ПараметрыФормы.Вставить("РежимПодбораБезСуммовыхПараметров",          ?(Параметры.Свойство("РежимПодбораБезСуммовыхПараметров"),
	                                                                        Параметры.РежимПодбораБезСуммовыхПараметров,
	                                                                        Ложь));
	
	Возврат ПараметрыФормы;
	
КонецФункции

// Формирует структуру параметров открытия формы примененных скидок, свойственных подсистеме самооблуживание.
//
// Возвращаемое значение:
//   Структура   - сформированая структура параметров
//
Функция ДополнительныеПараметрыПримененныеСкидки() Экспорт

	Возврат Новый Структура("НеВыводитьИнформациюОРучныхСкидках", Истина);

КонецФункции

// Формирует информационную надпись на форме документа ПланыПродаж для выделенной ячейки 
//
// Параметры
//  Элемент  - ЭлементФормы - активизированный элемент управления
//  Форма    - УправляемаяФорма - форма, для которой выполяются действия
//
Процедура ПланПродажТоварыПоПериодамПриАктивизацииЯчейки(Элемент, Форма) Экспорт
	
	Объект = Форма.Объект;
	
	Если НЕ Объект.ПланироватьПоСумме Тогда
		Возврат;
	КонецЕсли; 
	
	ТекущиеДанные = Форма.Элементы.ТоварыПоПериодам.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ИтогоПоКолонке = "";
	ИтогоПоСтроке = НСтр("ru='Всего по строке: %СуммаПоСтроке% %Валюта%';uk='Всього по рядку: %СуммаПоСтроке% %Валюта%'");
		
	ИтогоПоСтроке = СтрЗаменить(ИтогоПоСтроке, "%Валюта%", Строка(Объект.Валюта));
	ИтогоПоСтроке = СтрЗаменить(ИтогоПоСтроке, "%СуммаПоСтроке%", Формат(ТекущиеДанные.Сумма, "ЧДЦ=2; ЧН=0,00"));	
	
	Если Элемент.ТекущийЭлемент <> Неопределено Тогда
		Для каждого Период Из Форма.Периоды.НайтиСтроки(Новый Структура("Активная", Истина)) Цикл
			Если Элемент.ТекущийЭлемент.Имя = "ТоварыПоПериодамЦена_"+Период.ИмяКолонки 
				ИЛИ Элемент.ТекущийЭлемент.Имя = "ТоварыПоПериодамКоличество_"+Период.ИмяКолонки 
				ИЛИ Элемент.ТекущийЭлемент.Имя = "ТоварыПоПериодамСумма_"+Период.ИмяКолонки Тогда
				ПериодЗаголовок = Период.Заголовок;
				СуммаПоКолонке = Форма["ТоварыПоПериодамСумма_"+ Период.ИмяКолонки];
				ИтогоПоКолонке = НСтр("ru='Всего за период %ПериодЗаголовок%: %СуммаПоКолонке% %Валюта%';uk='Всього за період %ПериодЗаголовок%: %СуммаПоКолонке% %Валюта%'");
				ИтогоПоКолонке = СтрЗаменить(ИтогоПоКолонке, "%ПериодЗаголовок%", Период.Заголовок);
				ИтогоПоКолонке = СтрЗаменить(ИтогоПоКолонке, "%СуммаПоКолонке%", Формат(СуммаПоКолонке, "ЧДЦ=2; ЧН=0,00"));
				ИтогоПоКолонке = СтрЗаменить(ИтогоПоКолонке, "%Валюта%", Строка(Объект.Валюта));
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Форма.ИтогоПоСтрокеКолонке = ИтогоПоСтроке + " " + ИтогоПоКолонке;
	
КонецПроцедуры

// Заполняет список выбора действия при расхождении в документе АктПриемкиКлиента 
//
// Параметры
//  СписокВыбора - СписокЗначений - список, который заполняется
//  Расхождения  - Число - выявленные расхождения по количеству в строке
//
Процедура ЗаполнитьСписокВыбораДействийПриРасхождении(СписокВыбора, Расхождения, СпособОтраженияРасхождений) Экспорт

	Если Расхождения > 0 Тогда
		
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ВозвратПерепоставленного"));
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПокупкаПерепоставленного"));
		
	ИначеЕсли Расхождения < 0 Тогда
		
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ТребуетсяДопоставка"));
		СписокВыбора.Добавить(ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ДопоставкаНеТребуется"));
		
	Иначе
		
		Возврат;
		
	КонецЕсли;

КонецПроцедуры

Процедура ОткрытьОтчетОстаткиИДоступностьТоваров(Форма) Экспорт
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("СформироватьПриОткрытии",Истина);
	ПараметрыОткрытия.Вставить("КлючВарианта","ОстаткиИДоступностьТоваров");
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(Форма.СегментНоменклатуры) Тогда
		Отбор.Вставить("СегментНоменклатуры",Форма.СегментНоменклатуры);
	КонецЕсли;
	Если Форма.СкладОпределенСоглашением Тогда
		Если Форма.ИмяФормы = "Обработка.СамообслуживаниеПартнеров.Форма.КорзинаПокупателя" Тогда
			Отбор.Вставить("Склад",Форма.Склад)
		Иначе
			Отбор.Вставить("Склад",Форма.Объект.Склад);
		КонецЕсли;
	Иначе
		Отбор.Вставить("Склад",Форма.Элементы.Склад.СписокВыбора.Скопировать());
	КонецЕсли;
	
	Если Отбор.Количество() > 0 Тогда
		ПараметрыОткрытия.Вставить("Отбор",Отбор);
	КонецЕсли;
	
	ОткрытьФорму("Отчет.ОстаткиИДоступностьТоваров.Форма.ФормаОтчетаСамообслуживание", ПараметрыОткрытия);
	
КонецПроцедуры

#КонецОбласти

#Область АктПриемкиСоСтороныКлиента

Функция СтруктураПараметровФормыВыбораОснований() Экспорт

	СтруктураПараметров = Новый Структура(
	"Партнер,
	|Валюта,
	|УказаниеДоговораНеТребуется,
	|Договор,
	|ДокументыОснования,
	|Организация,
	|Соглашение,
	|Партнер,
	|Контрагент,
	|ХозяйственнаяОперация,
	|ЦенаВключаетНДС,
	|ТабличнаяЧастьНеПустая,
	|ТипОснованияАктаОРасхождении");
	
	Возврат СтруктураПараметров;

КонецФункции

Процедура ТоварыРеализацияПриИзменении(Форма) Экспорт
	
	ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Реализация) Тогда
		ТекущиеДанные.Склад        = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		ТекущиеДанные.ЗаказКлиента = ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка");
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = Форма.ДокументыОснования.НайтиСтроки(Новый Структура("Реализация", ТекущиеДанные.Реализация));
	Если НайденныеСтроки.Количество() = 0 Тогда
		ТекущиеДанные.Склад        = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		ТекущиеДанные.ЗаказКлиента = ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка");
		Возврат;
	КонецЕсли;
	
	НайденнаяСтрока = НайденныеСтроки[0];

	Если ЗначениеЗаполнено(ТекущиеДанные.ЗаказКлиента) Тогда
		Если НайденнаяСтрока.ЗаказыОснования.НайтиПоЗначению(ТекущиеДанные.ЗаказКлиента) = Неопределено Тогда
			ТекущиеДанные.ЗаказКлиента = ПредопределенноеЗначение("Документ.ЗаказКлиента.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Склад) Тогда
		Если НайденнаяСтрока.СкладыОснования.НайтиПоЗначению(ТекущиеДанные.Склад) = Неопределено Тогда
			ТекущиеДанные.Склад = ПредопределенноеЗначение("Справочник.Склады.ПустаяСсылка");
		КонецЕсли;
	КонецЕсли;
	
	СамообслуживаниеКлиентСервер.УстановитьПризнакДокументОснованиеПоЗаказу(ТекущиеДанные, НайденнаяСтрока);
	СамообслуживаниеКлиентСервер.ЗаполнитьЗаказИСкладВСтроке(ТекущиеДанные, Форма.ДокументыОснования);
	
КонецПроцедуры

Процедура УстановитьВариантДействия(Форма, ВариантДействия) Экспорт
	
	КоличествоИзмененныхСтрок = 0;
	
	Для Каждого ВыделеннаяСтрока Из Форма.Элементы.Товары.ВыделенныеСтроки Цикл
		
		ТекущиеДанные = Форма.Объект.Товары.НайтиПоИдентификатору(ВыделеннаяСтрока);
		Если ТекущиеДанные.Действие = ВариантДействия Тогда
			Продолжить;
		КонецЕсли;
		
		Если ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПокупкаПерепоставленного")
			Или ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ВозвратПерепоставленного")
			Или ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ОприходоватьСейчас")
			Или ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ПерепоставленноеДарится") Тогда
			
			Если НЕ ТекущиеДанные.КоличествоУпаковокРасхождения > 0  Тогда
				Продолжить;
			КонецЕсли;
			
		ИначеЕсли ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ТребуетсяДопоставка")
			Или ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ДопоставкаНеТребуется")
			Или ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.ОтгрузитьСейчас")
			Или ВариантДействия = ПредопределенноеЗначение("Перечисление.ВариантыДействийПоРасхождениямВАктеПослеОтгрузки.НедостачаНеПризнана") Тогда
			
			Если НЕ ТекущиеДанные.КоличествоУпаковокРасхождения < 0 Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		ТекущиеДанные.Действие = ВариантДействия;
		КоличествоИзмененныхСтрок = КоличествоИзмененныхСтрок + 1;
		
	КонецЦикла;
	
	ТекстОповещения =  НСтр("ru='Установка варианта действия строк';uk='Установка варіанту дії рядків'");
	ТекстПояснения = НСтр("ru='Строк, у которых установлен вариант действия %действие%: %КоличествоСтрок%.';uk='Рядків, у яких встановлений варіант дії %действие%: %КоличествоСтрок%.'");
	ТекстПояснения = СтрЗаменить(ТекстПояснения, "%действие%", Строка(ВариантДействия));
	ТекстПояснения = СтрЗаменить(ТекстПояснения, "%КоличествоСтрок%", Строка(КоличествоИзмененныхСтрок));
	
	ПоказатьОповещениеПользователя(ТекстОповещения,,ТекстПояснения);

КонецПроцедуры

Процедура КомментарийКлиентаНачалоВыбора(Форма) Экспорт

	ТекущиеДанные = Форма.Элементы.Товары.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ТекущиеДанные", ТекущиеДанные);
	ДополнительныеПараметры.Вставить("ИмяРеквизитаКомментарий", "КомментарийКлиента");
	ДополнительныеПараметры.Вставить("ИмяРеквизитаЕстьКомментарий", "ЕстьКомментарийКлиента");
	ДополнительныеПараметры.Вставить("Форма", Форма);

	ОписаниеОповещенияЗавершение = Новый ОписаниеОповещения("РедактированиеКомментарияЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияМногострочногоТекста(ОписаниеОповещенияЗавершение, ТекущиеДанные.КомментарийКлиента);
	

КонецПроцедуры

Процедура РедактированиеКомментарияЗавершение(РезультатРедактирования, ДополнительныеПараметры) Экспорт
	
	Если РезультатРедактирования = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	Если РезультатРедактирования <> ДополнительныеПараметры.ТекущиеДанные[ДополнительныеПараметры.ИмяРеквизитаКомментарий] Тогда
		ДополнительныеПараметры.ТекущиеДанные[ДополнительныеПараметры.ИмяРеквизитаКомментарий]     = РезультатРедактирования;
		ДополнительныеПараметры.ТекущиеДанные[ДополнительныеПараметры.ИмяРеквизитаЕстьКомментарий] = Не ПустаяСтрока(РезультатРедактирования);
		ДополнительныеПараметры.Форма.Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область Печать

// Выводит печатную форму документа "Заказ клиента" по умолчанию
//
// Параметры
//  ОбъектПечати  - ДокумементСсылка.ЗаказКлиента, Массив - документы, печатные формы которых выводятся.
//
Процедура ПечатьДокументЗаказ(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьЗаказовНаТоварыУслуги",
		"ЗаказКлиента",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);
	
КонецПроцедуры

// Выводит печатную форму документа "Заказ клиента" по умолчанию
//
// Параметры
//  ОбъектПечати  - ДокумементСсылка.ЗаказКлиента, Массив - документы, печатные формы которых выводятся.
//
Процедура ПечатьДокументПлан(ОбъектПечати) Экспорт
	
	ПараметрыПечати = Новый Структура;
	ПараметрыПечати.Вставить("ВыводитьСценарий"     , Ложь);
	ПараметрыПечати.Вставить("ВыводитьПодразделение", Ложь);
	ПараметрыПечати.Вставить("ВыводитьСоглашениеВТЧ", Ложь);
	ПараметрыПечати.Вставить("ВыводитьСкладВТЧ"     , Ложь);
	ПараметрыПечати.Вставить("ВыводитьПартнераВТЧ"  , Ложь);
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
	    "Документ.ПланПродаж",
	    "ПланПродаж",
	     ДанныеПечати(ОбъектПечати),
	     Неопределено,
	     ПараметрыПечати);
	
КонецПроцедуры

// Выводит печатную форму документа "Заявка на возврат товаров от клиента" по умолчанию
//
// Параметры
//  ОбъектПечати  - ДокумементСсылка.ЗаявкаНаВозвратТоваровОтКлиента, Массив - документы, печатные формы которых выводятся.
//
 Процедура ПечатьДокументЗаявкаНаВозврат(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.ЗаявкаНаВозвратТоваровОтКлиента",
		"ЗаявкаНаВозврат",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);
		
КонецПроцедуры

// Выводит печатную форму документа "Акт выполненных работ" по умолчнанию
//
// Параметры
//  ОбъектПечати  - ДокументСсылка.АктВыполненныхРабот, Массив - документы, печатные формы которых выводятся.
//
Процедура ПечатьАктВыполненныхРабот(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
        "Обработка.ПечатьАктОбОказанииУслуг",
		"Акт",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);

КонецПроцедуры

// Выводит печатную форму документа "Реализация товаров и услуг" по умолчнанию
//
// Параметры
//  ОбъектПечати  - ДокументСсылка.РеализацияТоваровУслуг, Массив - документы, печатные формы которых выводятся.
//
Процедура ПечатьРеализацияТоваровУслуг(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
	         "Обработка.ПечатьОбщихФорм",
	         "РасходнаяНакладная",
	         ДанныеПечати(ОбъектПечати),
	         Неопределено,
	         Неопределено);
	
КонецПроцедуры

// Выводит печатную форму документа "Реализация товаров и услуг" по умолчнанию
//
// Параметры
//  ОбъектПечати  - ДокументСсылка.РеализацияТоваровУслуг, Массив - документы, печатные формы которых выводятся.
//
Процедура ПечатьСчетНаОплату(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьСчетовНаОплату",
		"СчетНаОплату",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);
	
КонецПроцедуры

// Выводит печатную форму претензии клиента
//
// Параметры
//  ОбъектПечати  - СправочникСсылка.ПретензияКлиента, Массив - претензии, печатные формы которых выводятся.
//
Процедура ПечатьПретензияКлиента(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.ПретензииКлиентов",
		"ПретензияКлиента",
		ДанныеПечати(ОбъектПечати),
		Неопределено,);
	
КонецПроцедуры

// Выводит печатную форму карточки номенклатуры
//
// Параметры
//  ОбъектПечати  - СправочникСсылка.Номенклатура, Массив - номенклатура, печатные формы которых выводятся.
//
Процедура ПечатьКарточкаНоменклатуры(ОбъектПечати) Экспорт

	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.Номенклатура",
		"КарточкаНоменклатуры",
		ДанныеПечати(ОбъектПечати),
		Неопределено,);
	
КонецПроцедуры

// Выводит печатную форму документа "Заказ клиента" по умолчанию
//
// Параметры
//  ОбъектПечати  - ДокумементСсылка.ЗаказКлиента, Массив - документы, печатные формы которых выводятся.
//
 Процедура ПечатьДокументОтчетКомиссионера(ОбъектПечати) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Обработка.ПечатьОбщихФорм",
		"ОтчетКомиссионера",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);
	
КонецПроцедуры

// Выводит печатную форму "Соглашения об условиях продаж" по умолчанию
//
// Параметры
//  ОбъектПечати  - СправочникСсылка.СоглашенияСКлиентами, Массив - соглашения, печатные формы которых выводятся.
//
 Процедура ПечатьСоглашениеСКлиентом(ОбъектПечати) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Справочник.СоглашенияСКлиентами",
		"СоглашениеСКлиентом",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);
	
КонецПроцедуры


// Выводит печатную форму "Акта приемки клиентом"
//
// Параметры
//  ОбъектПечати  - ДокументСсылка, Массив - документы, печатные формы которых выводятся.
//
Процедура ПечатьАктПриемки(ОбъектПечати) Экспорт
	
	УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
		"Документ.АктОРасхожденияхПослеОтгрузки",
		"ТОРГ1",
		ДанныеПечати(ОбъектПечати),
		Неопределено,
		Неопределено);
	
КонецПроцедуры
	
Функция ДанныеПечати(ОбъектПечати)

	Если НЕ ТипЗнч(ОбъектПечати)= Тип("Массив") Тогда
		МассивОбъектовПечати = Новый Массив;
		МассивОбъектовПечати.Добавить(ОбъектПечати);
		Возврат МассивОбъектовПечати;
	Иначе
		Возврат ОбъектПечати;
	КонецЕсли;

КонецФункции

#КонецОбласти

#КонецОбласти
