#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Организация",  Организация);
	Параметры.Свойство("Период",       ПериодРасчетов);
	
	СпецРежимНалогообложения = -1;
	
	УстановитьПериодРасчетов(ПериодРасчетов);
	ПредыдущийПериодРасчетов = ПериодРасчетов;
	
	НДСОбщегоНазначенияСервер.ЗаполнитьСписокВыбораСпецРежимаНалогообложения(СписокСпецРежимовПолный);
	
	// СписокНН
	УстановитьТекстЗапросаДинамическогоСписка(Истина);
	// СписокП2
	УстановитьТекстЗапросаДинамическогоСписка(Ложь);
	
	ОбновитьДанныеНаСервере();
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеОтчетыИОбработкиКлиентСервер.ТипФормыСписка());
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюОтчеты,, Ложь);
	// Конец МенюОтчеты
	
	ВводНаОсновании.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюСоздатьНаОсновании);

	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	УстановитьПериодРасчетов(ПериодРасчетов);
	СпецРежимНалогообложения = -1;
	Если ПредыдущаяОрганизация <> Организация Тогда
		ОбновитьДанныеНаСервере();
		ПредыдущаяОрганизация = Организация;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы 

&НаКлиенте
Процедура СформироватьП2КВыбраннымДокументам(Команда)

	ВыделенныеСтроки = Элементы.СписокНН.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(, НСтр("ru='Необходимо выделить строки в списке!';uk='Необхідно виділити рядки в списку!'"));
		Возврат;
	КонецЕсли;
	
	Если СуммаКорректировкиНДС <> 0 Тогда
		ТекстВопроса = НСтр("ru='Уже есть созданные документы корректировки (вкладка ""Налоговые документы""). В процессе выполнения команды они будут помечены на удаление. Продолжить?';uk='Вже є створені документи коригування (вкладка ""Податкові документи""). В процесі виконання команди вони будуть позначені на видалення. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("СформироватьНалоговыеДокументыЗавершение", ЭтотОбъект, Истина);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;	
	
	СформироватьНалоговыеДокументыСервер(Истина);
	Элементы.СписокП2.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьП2КоВсемНН(Команда)
	
	Если СуммаКорректировкиНДС <> 0 Тогда
		ТекстВопроса = НСтр("ru='Уже есть созданные документы корректировок (вкладка ""Налоговые документы""). В процессе выполнения команды они будут помечены на удаление. Продолжить?';uk='Вже є створені документи коригувань (вкладка ""Податкові документи""). В процесі виконання команди вони будуть позначені на видалення. Продовжити?'");
		Оповещение = Новый ОписаниеОповещения("СформироватьНалоговыеДокументыЗавершение", ЭтотОбъект, Ложь);
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Возврат;
	КонецЕсли;
	
	СформироватьНалоговыеДокументыСервер(Ложь);
	Элементы.СписокП2.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьНалоговыеДокументыЗавершение(Ответ, ФормироватьПоВыделеннымСтрокам) Экспорт

	Если Не Ответ = КодВозвратаДиалога.Да Тогда
		Возврат;	
	КонецЕсли; 	
	
	СформироватьНалоговыеДокументыСервер(ФормироватьПоВыделеннымСтрокам);
	Элементы.СписокП2.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	ОбновитьДанныеНаСервере();
	
	Элементы.СписокНН.Обновить();
	Элементы.СписокП2.Обновить();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Элементы.СписокП2);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтаФорма, Элементы.СписокП2);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	Если ПредыдущаяОрганизация <> Организация Тогда
		СпецРежимНалогообложения = -1;
		ОбновитьДанныеНаСервере();
		ПредыдущаяОрганизация = Организация;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСпецРежимНалогообложенияПриИзменении(Элемент)
	
	ОбновитьДанныеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодРасчетовПриИзменении(Элемент)

	УстановитьПериодРасчетов(ПериодРасчетов);
	
	Если ПредыдущийПериодРасчетов <> ПериодРасчетов Тогда
		СпецРежимНалогообложения = -1;
		ОбновитьДанныеНаСервере();
		ПредыдущийПериодРасчетов = ПериодРасчетов;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодРасчетовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Диалог = Новый ДиалогРедактированияСтандартногоПериода();
	Диалог.Период = Новый СтандартныйПериод(НачалоГода(ПериодРасчетов), КонецГода(ПериодРасчетов));
	
	Диалог.Показать(Новый ОписаниеОповещения("ОтборПериодРасчетовНачалоВыбораЗавершение", ЭтотОбъект)); 
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПериодРасчетовНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(РезультатВыбора) Тогда
		ПериодРасчетов = НачалоГода(РезультатВыбора.ДатаНачала);
		ОтборПериодРасчетовПриИзменении(Элементы.ОтборПериодРасчетов);
	КонецЕсли; 
	
КонецПроцедуры 

&НаКлиенте
Процедура СписокП2ПриИзменении(Элемент)
	СписокП2ПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьЭлементыФормы()
	
	ЗаполненыОтборы = (ЗначениеЗаполнено(Организация) И (Не НесколькоСпецРежимовДляОрганизации Или (НесколькоСпецРежимовДляОрганизации И СпецРежимНалогообложения <> -1)))  
		Или (Не ЗначениеЗаполнено(Организация) И Не НесколькоОрганизаций И Не НесколькоСпецРежимовДляОрганизации);
	
	Элементы.СписокННСформироватьП2КВыбраннымДокументам.Доступность = ЗаполненыОтборы И ПредполагаемаяСуммаКорректировкиНДС <> 0;
	Элементы.СписокННСформироватьП2КоВсемНН.Доступность = ПредполагаемаяСуммаКорректировкиНДС <> 0;
	
	Элементы.ОтборСпецРежимНалогообложения.Видимость = НесколькоСпецРежимовДляОрганизации;
	
	СписокВыбораСпецРежимов = Элементы.ОтборСпецРежимНалогообложения.СписокВыбора;
	СписокВыбораСпецРежимов.Очистить();
	Для каждого ЭлементСписка Из СпецРежимыОрганизации Цикл
		СписокВыбораСпецРежимов.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);	
	КонецЦикла;
	
 	ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС = "";
	СвойствоГиперСсылкаДекорацииПредполагаемаяСуммаКорректировкиНДС = Ложь;
	Если Не ЗначениеЗаполнено(Организация) И НесколькоОрганизаций Тогда
		ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС = НСтр("ru='Cумма НДС к оформлению (для всех организаций): %1';uk='Сума ПДВ до оформлення (для всіх організацій): %1'");
		СвойствоГиперСсылкаДекорацииПредполагаемаяСуммаКорректировкиНДС = Истина;
	ИначеЕсли ЗначениеЗаполнено(Организация) И НесколькоСпецРежимовДляОрганизации И СпецРежимНалогообложения = -1 Тогда
		ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС = НСтр("ru='Сумма НДС к оформлению (для всех спец режимов организации): %1';uk='Сума ПДВ до оформлення (для всіх спец режимів організації): %1'");
		СвойствоГиперСсылкаДекорацииПредполагаемаяСуммаКорректировкиНДС = Истина;
	Иначе	
	    ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС = НСтр("ru='Сумма НДС к оформлению: %1';uk='Сума ПДВ до оформлення: %1'");
		СвойствоГиперСсылкаДекорацииПредполагаемаяСуммаКорректировкиНДС = Ложь;
	КонецЕсли;
	ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС = СтрЗаменить(ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС, "%1", Формат(ПредполагаемаяСуммаКорректировкиНДС, "ЧДЦ=2; ЧН=; ЧГ=3,0"));
	
	Элементы.ДекорацияПредполагаемаяСуммаКорректировкиНДС.Заголовок = ЗаголовокДекорацииПредполагаемаяСуммаКорректировкиНДС;
	Элементы.ДекорацияПредполагаемаяСуммаКорректировкиНДС.Гиперссылка = СвойствоГиперСсылкаДекорацииПредполагаемаяСуммаКорректировкиНДС;
	
	ЗаголовокДекорацииСуммаКорректировкиНДС = НСтр("ru='Сумма НДС оформлено: %1';uk='Сума ПДВ оформлено: %1'");
	ЗаголовокДекорацииСуммаКорректировкиНДС = СтрЗаменить(ЗаголовокДекорацииСуммаКорректировкиНДС, "%1", Формат(СуммаКорректировкиНДС, "ЧДЦ=2; ЧН=; ЧГ=3,0"));
	Элементы.ДекорацияСуммаКорректировкиНДС.Заголовок = ЗаголовокДекорацииСуммаКорректировкиНДС;
	//Элементы.ДекорацияСуммаКорректировкиНДС.Видимость = СуммаКорректировкиНДС <> 0;
	
	Элементы.ДекорацияРазделитель.Видимость = Элементы.ДекорацияСуммаКорректировкиНДС.Видимость;
	
КонецПроцедуры

&НаСервере
Процедура СформироватьНалоговыеДокументыСервер(ФормироватьПоВыделеннымСтрокам = Ложь)	 

	СписокНалоговыхНакладных = Неопределено;
	Если ФормироватьПоВыделеннымСтрокам Тогда
		СписокНалоговыхНакладных = Новый Массив;
		Для каждого ДокументСтроки Из Элементы.СписокНН.ВыделенныеСтроки Цикл
			СписокНалоговыхНакладных.Добавить(ДокументСтроки); 
		КонецЦикла; 
	КонецЕсли; 

	ПараметрыОтбора = ПолучитьПараметрыОтбора();
	
	НДСИсходящийСервер.СформироватьДокументыПриложение2ПоУсловнымПродажамПропорциональныйНДС(ПараметрыОтбора, СписокНалоговыхНакладных);
	
	ОбновитьСуммуКорректировкиНДС(ПараметрыОтбора);	
	НастроитьЭлементыФормы();
	
КонецПроцедуры
    
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПериодРасчетов(ПериодРасчетов)
	
	Если ЗначениеЗаполнено(ПериодРасчетов) Тогда
		ПериодРасчетов = НачалоГода(ПериодРасчетов);
	Иначе	
		ТекДата = ТекущаяДата();
		Если Месяц(ТекДата) = 12 Тогда
			ПериодРасчетов = НачалоГода(ТекДата);	
		Иначе	
			ПериодРасчетов = НачалоГода(НачалоГода(ТекДата) - 1);
		КонецЕсли;
	КонецЕсли;	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьПараметры()
	
	ЗапросСуммыКорректировокНК = Новый Запрос;
	ЗапросСуммыКорректировокНК.Текст = НДСИсходящийСервер.ТекстЗапросаСуммыКорректировокПропорциональногоНДС();
	
	НДСИсходящийСервер.УстановитьПараметрыЗапросаКорректировкаПоПропорциональномуНДС(ЗапросСуммыКорректировокНК, ПолучитьПараметрыОтбора());
	
	Выборка = ЗапросСуммыКорректировокНК.Выполнить().Выбрать();
	
	ОтборПоСпецРежиму = НЕ (СпецРежимНалогообложения = -1);
	
	// Обнуление реквизитов формы
	ПредполагаемаяСуммаКорректировкиНДС = 0;
	СуммаКорректировкиНДС = 0;
	НесколькоОрганизаций = Ложь;
	Если НЕ ОтборПоСпецРежиму Тогда
		НесколькоСпецРежимовДляОрганизации = Ложь;
		СпецРежимыОрганизации.Очистить();
	КонецЕсли;
	
	// Локальные переменные
	ОрганизацияПредыдущая = Неопределено;
	СпецРежимПредыдущий = Неопределено;
	
	УказанаОрганизация = ЗначениеЗаполнено(Организация);
	
	Пока Выборка.Следующий() Цикл
		
		// Общую сумму по всем организациям показывать не очень корректно, но ожидается, что в основном будет установлен отбор по организации
		ПредполагаемаяСуммаКорректировкиНДС = ПредполагаемаяСуммаКорректировкиНДС + Выборка.ПредполагаемаяСуммаКорректировкиНДС;
		СуммаКорректировкиНДС = СуммаКорректировкиНДС + Выборка.СуммаКорректировкиНДС;
		
		Если (Не ОрганизацияПредыдущая = Неопределено) И (ОрганизацияПредыдущая <> Выборка.Организация) Тогда
			НесколькоОрганизаций = Истина;	
		КонецЕсли;
		ОрганизацияПредыдущая = Выборка.Организация;
		
		// Спец режим налогообложения
		Если ОтборПоСпецРежиму Тогда
			Продолжить;
		КонецЕсли;
		
		Если УказанаОрганизация И (СпецРежимПредыдущий <> Выборка.СпецРежимНалогообложения) Тогда
			
			Если Не СпецРежимПредыдущий = Неопределено Тогда 
				НесколькоСпецРежимовДляОрганизации = Истина;
			КонецЕсли;
			
			ЭлементСписка = СписокСпецРежимовПолный.НайтиПоЗначению(Выборка.СпецРежимНалогообложения);
				
			Если ЭлементСписка = Неопределено Тогда
				ПредставлениеСпецРежимаНалогообложения = Строка(СпецРежимНалогообложения);    // такого случая быть не должно
			Иначе	
			    ПредставлениеСпецРежимаНалогообложения = ЭлементСписка.Представление;
			КонецЕсли; 
			
			СпецРежимыОрганизации.Добавить(Выборка.СпецРежимНалогообложения, ПредставлениеСпецРежимаНалогообложения);
		КонецЕсли;
		СпецРежимПредыдущий = Выборка.СпецРежимНалогообложения;
		
	КонецЦикла;
	
	Если Не ОтборПоСпецРежиму И НесколькоСпецРежимовДляОрганизации Тогда
		СпецРежимыОрганизации.Вставить(0, -1, НСтр("ru='<без отбора>';uk='<без відбору>'"));
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСуммуКорректировкиНДС(ПараметрыОтбора = Неопределено)

	ТекстЗапроса = НДСИсходящийСервер.ТекстЗапросаСуммыКорректировокПропорциональногоНДС(Истина);	
	ТекстЗапроса = ТекстЗапроса + Символы.ПС +
	"
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|
	|" +
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.СуммаКорректировкиНДС
	|ИЗ
	|	(ВЫБРАТЬ
	|		СУММА(ВТКорректировкиУсловныхПродаж.СуммаКорректировкиНДС) КАК СуммаКорректировкиНДС 
	|	ИЗ
	|		ВТКорректировкиУсловныхПродаж КАК ВТКорректировкиУсловныхПродаж) КАК ВложенныйЗапрос
	|ГДЕ
	|	НЕ ВложенныйЗапрос.СуммаКорректировкиНДС ЕСТЬ NULL";
	
	ЗапросСуммыКорректировокНК = Новый Запрос;
	ЗапросСуммыКорректировокНК.Текст = ТекстЗапроса;
	
	Если ПараметрыОтбора = Неопределено Тогда
		ПараметрыОтбора = ПолучитьПараметрыОтбора();
	КонецЕсли; 
	НДСИсходящийСервер.УстановитьПараметрыЗапросаКорректировкаПоПропорциональномуНДС(ЗапросСуммыКорректировокНК, ПараметрыОтбора);
	
	РезультатЗапроса = ЗапросСуммыКорректировокНК.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		СуммаКорректировкиНДС = 0;	
	Иначе	
	    Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		СуммаКорректировкиНДС = Выборка.СуммаКорректировкиНДС;
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура ДекорацияСуммаКорректировкиНДСНажатие(Элемент)
	
	Отбор = Новый Структура;
	Если ЗначениеЗаполнено(Организация) Тогда
		Отбор.Вставить("Организация", Организация);
	КонецЕсли;
	
	Отбор.Вставить("НачалоПериода", НачалоГода(ПериодРасчетов));
	Отбор.Вставить("КонецПериода",  КонецГода (ПериодРасчетов));
	Отбор.Вставить("ВидУсловнойПродажи", ПредопределенноеЗначение("Перечисление.ВидУсловнойПродажи.ПредполагаемаяКорректировкаУсловнойПродажи"));
	
	ПараметрыФормы = Новый Структура("Отбор", Отбор);
	
	ОткрытьФорму("РегистрНакопления.СуммыКорректировокПропорциональногоНДС.ФормаСписка", ПараметрыФормы, ЭтотОбъект,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры 

&НаСервере
Процедура ОбновитьДанныеНаСервере()

	ОбновитьПараметры(); 
	
	// СписокНН
	УстановитьПараметрыДинамическогоСписка(Истина);
	// СписокП2
	УстановитьПараметрыДинамическогоСписка(Ложь);
	
	НастроитьЭлементыФормы();

КонецПроцедуры

&НаСервере
Функция ПолучитьПараметрыОтбора()

	ПараметрыОтбора = Новый Структура("Организация,СпецРежимНалогообложения,ПериодРасчетов", 
		Организация, СпецРежимНалогообложения, ПериодРасчетов);
	
	Возврат ПараметрыОтбора;

КонецФункции

&НаСервере
Процедура УстановитьТекстЗапросаДинамическогоСписка(НалоговаяНакладная = Истина)
	
	Если НалоговаяНакладная Тогда
		Список = СписокНН;	
	Иначе	
	    Список = СписокП2;
	КонецЕсли; 
		
	Список.ТекстЗапроса = НДСИсходящийСервер.ТекстЗапросаДинамическогоСпискаНалоговыхДокументов(НалоговаяНакладная);
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьПараметрыДинамическогоСписка(НалоговаяНакладная = Истина)
	
	Если НалоговаяНакладная Тогда
		Список = СписокНН;	
	Иначе	
	    Список = СписокП2;
	КонецЕсли;
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "НачалоГода", НачалоГода(ПериодРасчетов));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "КонецГода", КонецГода(ПериодРасчетов));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "Организация", Организация);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ПоВсемОрганизациям", Не ЗначениеЗаполнено(Организация));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "СпецРежимНалогообложения", СпецРежимНалогообложения);
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ПоВсемСпецРежимамНалогообложения", СпецРежимНалогообложения = -1);
	
КонецПроцедуры	

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	////

	Элемент = УсловноеОформление.Элементы.Добавить();

	//Поле: ВидОперации
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокП2ВидОперации.Имя);
	//Отбор
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокП2.ВидОперации");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = ПредопределенноеЗначение("Перечисление.ВидыОперацийНалоговыхДокументов.СводнаяУсловнаяПродажа");

	//Оформления
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru='Корректировка условной продажи';uk='Коригування умовного продажу'")); 
	
КонецПроцедуры

&НаСервере
Процедура СписокП2ПриИзмененииНаСервере()

	ОбновитьСуммуКорректировкиНДС();
	НастроитьЭлементыФормы();

КонецПроцедуры

#КонецОбласти
