////////////////////////////////////////////////////////////////////////////////
// Подсистема "Выгрузка загрузка данных".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает зависимости неразделенных объектов метаданных.
// Если объект метаданных содержит поле, типом значения которого является ссылка на другой объект метаданных
// считается, что он от него зависит.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие:
//    * Ключ - Строка, полное имя зависимого объекта метаданных,
//    * Значение - Массив(Строка) - полные имена объектов метаданных, от которых зависит данный объект метаданных.
//
Функция ЗависимостиНеразделенныхОбъектовМетаданных() Экспорт
	
	Кэш = Новый Соответствие();
	
	ТипыОбщихКлассификаторов = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	
	Для Каждого ТипОбщегоКлассификатора Из ТипыОбщихКлассификаторов Цикл
		
		Менеджер = ТехнологияСервисаИнтеграцияСБСП.МенеджерОбъектаПоПолномуИмени(ТипОбщегоКлассификатора.ПолноеИмя());
		
		ПоляЕстественногоКлюча = Менеджер.ПоляЕстественногоКлюча();
		Для Каждого ПолеЕстественногоКлюча Из ПоляЕстественногоКлюча Цикл
			
			ТипыПоля = Неопределено;
			
			Для Итератор = 0 По ТипОбщегоКлассификатора.СтандартныеРеквизиты.Количество() - 1 Цикл
				
				// Поиск в стандартных реквизитах
				СтандартныйРеквизит = ТипОбщегоКлассификатора.СтандартныеРеквизиты[Итератор];
				Если СтандартныйРеквизит.Имя = ПолеЕстественногоКлюча Тогда
					ТипыПоля = СтандартныйРеквизит.Тип;
				КонецЕсли;
				
			КонецЦикла;
			
			// Поиск в реквизитах
			Реквизит = ТипОбщегоКлассификатора.Реквизиты.Найти(ПолеЕстественногоКлюча);
			Если Реквизит <> Неопределено Тогда
				ТипыПоля = Реквизит.Тип;
			КонецЕсли;
			
			// Поиск в общих реквизитах
			ОбщийРеквизит = Метаданные.ОбщиеРеквизиты.Найти(ПолеЕстественногоКлюча);
			Если ОбщийРеквизит <> Неопределено Тогда
				Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
					Если ОбщийРеквизит.Состав.Найти(ТипОбщегоКлассификатора) <> Неопределено Тогда
						ТипыПоля = ОбщийРеквизит.Тип;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТипыПоля = Неопределено Тогда
				
				ВызватьИсключение СтрШаблон(НСтр("ru='Поле %1 не может использоваться в качестве поля естественного ключа объекта %2:
                          |поле объекта не обнаружено!'
                          |;uk='Поле %1 не може використовуватися в якості поля природного ключа об''єкту %2:
                          |поле об''єкта не виявлено!'",Метаданные.ОсновнойЯзык.КодЯзыка),
					ПолеЕстественногоКлюча,
					ТипОбщегоКлассификатора.ПолноеИмя()
				);
				
			КонецЕсли;
			
			Для Каждого ТипПоля Из ТипыПоля.Типы() Цикл
				
				Если Не ОбщегоНазначенияБТС.ЭтоПримитивныйТип(ТипПоля) И Не ОбщегоНазначенияБТС.ЭтоПеречисление(ВыгрузкаЗагрузкаДанныхСлужебный.ОбъектМетаданныхПоТипуСсылки(ТипПоля)) Тогда
					
					Если ТипПоля = Тип("ХранилищеЗначения") Тогда
						
						ВызватьИсключение СтрШаблон(
							НСтр("ru='Поле %1 не может использоваться в качестве поля естественного ключа объекта %2: использование
                                  |значений типа ХранилищеЗначения в качестве полей естественного ключа не поддерживается!'
                                  |;uk='Поле %1 не може використовуватися в якості поля природного ключа об''єкту %2: використання
                                  |значень типу ХранилищеЗначения в якості полів природного ключа не підтримується!'",Метаданные.ОсновнойЯзык.КодЯзыка),
							ПолеЕстественногоКлюча,
							ТипОбщегоКлассификатора.ПолноеИмя()
						);
						
					КонецЕсли;
					
					Ссылка = Новый(ТипПоля);
					
					Если ТипыОбщихКлассификаторов.Найти(Ссылка.Метаданные()) <> Неопределено Тогда
						
						Если Кэш.Получить(ТипОбщегоКлассификатора.ПолноеИмя()) <> Неопределено Тогда
							Кэш.Получить(ТипОбщегоКлассификатора.ПолноеИмя()).Добавить(Ссылка.Метаданные().ПолноеИмя());
						Иначе
							НовыйМассив = Новый Массив();
							НовыйМассив.Добавить(Ссылка.Метаданные().ПолноеИмя());
							Кэш.Вставить(ТипОбщегоКлассификатора.ПолноеИмя(), НовыйМассив);
						КонецЕсли;
						
					Иначе
						
						ВызватьИсключение СтрШаблон(
							НСтр("ru='Поле %1 не может использоваться в качестве поля естественного ключа объекта %2:
                                  |в качестве типа поля может использоваться объект %3, который не включен в набор
                                  |общих данных через переопределяемую процедуру
                                  |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке()'
                                  |;uk='Поле %1 не може використовуватися в якості поля природного ключа об''єкту %2:
                                  |в якості типу поля може використовуватися об''єкт %3, який не включений у набір
                                  |загальних даних через переобумовлену процедуру
                                  |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке()'",Метаданные.ОсновнойЯзык.КодЯзыка),
							ПолеЕстественногоКлюча,
							ТипОбщегоКлассификатора.ПолноеИмя(),
							Ссылка.Метаданные().ПолноеИмя()
						);
						
					КонецЕсли;
					
					
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Кэш);
	
КонецФункции

// Возвращает правила контроля ссылок на неразделенные данные в разделенных при выгрузке.
//
// Возвращаемое значение:
//  ФиксированноеСоответствие:
//    * Ключ - Строка - полное имя объекта метаданных, для которого должен выполняться контроль
//       наличия ссылок на неразделенные данные в разделенных при выгрузке данных.
//    * Значение - Массив(Строка) - массив имен полей объекта, в которых должен выполняться
//       контроль наличия ссылок на неразделенные данные в разделенных при выгрузке данных.
//
Функция КонтрольСсылокНаНеразделенныеДанныеВРазделенныхПриВыгрузке() Экспорт
	
	Кэш = Новый Соответствие();
	
	ТипыОбщихДанных = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхПоддерживающиеСопоставлениеСсылокПриЗагрузке();
	ОбъектыИсключаемыеИзВыгрузкиЗагрузки = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыИсключаемыеИзВыгрузкиЗагрузки();
	ОбъектыНеТребующиеСопоставленияСсылок = ВыгрузкаЗагрузкаДанныхСлужебныйСобытия.ПолучитьТипыОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке();
	
	ЛокальныйКэшСоставовРазделителей = Новый Соответствие();
	
	Для Каждого ОбъектМетаданных Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеКонстанты() Цикл
		ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеДляКонстант(
			Кэш, ОбъектМетаданных, ТипыОбщихДанных, ОбъектыИсключаемыеИзВыгрузкиЗагрузки, ОбъектыНеТребующиеСопоставленияСсылок,
				ЛокальныйКэшСоставовРазделителей
		);
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеСсылочныеДанные() Цикл
		ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеДляОбъектов(
			Кэш, ОбъектМетаданных, ТипыОбщихДанных, ОбъектыИсключаемыеИзВыгрузкиЗагрузки, ОбъектыНеТребующиеСопоставленияСсылок,
				ЛокальныйКэшСоставовРазделителей
		);
	КонецЦикла;
	
	Для Каждого ОбъектМетаданных Из ВыгрузкаЗагрузкаДанныхСлужебный.ВсеНаборыЗаписей() Цикл
		ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеДляНаборовЗаписей(
			Кэш, ОбъектМетаданных, ТипыОбщихДанных, ОбъектыИсключаемыеИзВыгрузкиЗагрузки, ОбъектыНеТребующиеСопоставленияСсылок,
				ЛокальныйКэшСоставовРазделителей
		);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(Кэш);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеДляКонстант(Кэш, Знач ОбъектМетаданных, Знач ТипыОбшихДанных, Знач ОбъектыИсключаемыеИзВыгрузкиЗагрузки, Знач ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей)
	
	Если ОбъектыИсключаемыеИзВыгрузкиЗагрузки.Найти(ОбъектМетаданных) = Неопределено И ВыгрузкаЗагрузкаНеразделенныхДанных.ОбъектМетаданныхРазделенХотьОднимРазделителем(ОбъектМетаданных, ЛокальныйКэшСоставаРазделителей) Тогда
		
		ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(
			Кэш, ОбъектМетаданных, ОбъектМетаданных, ТипыОбшихДанных, ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей
		);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеДляОбъектов(Кэш, Знач ОбъектМетаданных, Знач ТипыОбщихДанных, Знач ОбъектыИсключаемыеИзВыгрузкиЗагрузки, Знач ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей)
	
	Если ОбъектыИсключаемыеИзВыгрузкиЗагрузки.Найти(ОбъектМетаданных) = Неопределено И ВыгрузкаЗагрузкаНеразделенныхДанных.ОбъектМетаданныхРазделенХотьОднимРазделителем(ОбъектМетаданных, ЛокальныйКэшСоставаРазделителей) Тогда
		
		Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
			
			ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(
				Кэш, ОбъектМетаданных, Реквизит, ТипыОбщихДанных, ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей
			);
			
		КонецЦикла;
		
		Для Каждого ТабличнаяЧасть Из ОбъектМетаданных.ТабличныеЧасти Цикл
			
			Для Каждого Реквизит Из ТабличнаяЧасть.Реквизиты Цикл
				
				ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(
					Кэш, ОбъектМетаданных, Реквизит, ТипыОбщихДанных, ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей
				);
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеДляНаборовЗаписей(Кэш, Знач ОбъектМетаданных, Знач ТипыОбщихДанных, Знач ОбъектыИсключаемыеИзВыгрузкиЗагрузки, Знач ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей)
	
	Если ОбъектыИсключаемыеИзВыгрузкиЗагрузки.Найти(ОбъектМетаданных) = Неопределено И ВыгрузкаЗагрузкаНеразделенныхДанных.ОбъектМетаданныхРазделенХотьОднимРазделителем(ОбъектМетаданных, ЛокальныйКэшСоставаРазделителей) Тогда
		
		Для Каждого Измерение Из ОбъектМетаданных.Измерения Цикл
			
			ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(
				Кэш, ОбъектМетаданных, Измерение, ТипыОбщихДанных, ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей
			);
			
		КонецЦикла;
		
		Для Каждого Ресурс Из ОбъектМетаданных.Ресурсы Цикл
			
			ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(
				Кэш, ОбъектМетаданных, Ресурс, ТипыОбщихДанных, ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей
			);
			
		КонецЦикла;
		
		Для Каждого Реквизит Из ОбъектМетаданных.Реквизиты Цикл
			
			ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(
				Кэш, ОбъектМетаданных, Реквизит, ТипыОбщихДанных, ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставаРазделителей
			);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКэшКонтроляСсылокНаНеразделенныеДанныеПриВыгрузкеПоПолюРазделенногоОбъекта(Кэш, Знач ОбъектМетаданных, Знач Поле, Знач ТипыОбщихДанных, Знач ОбъектыНеТребующиеСопоставленияСсылок, ЛокальныйКэшСоставовРазделителей)
	
	ТипыПоля = Поле.Тип;
	
	Если ОбщегоНазначенияБТС.ЭтоНаборТиповСсылок(ТипыПоля) Тогда
		
		// Для реквизита установлен тип ЛюбаяСсылка или составной тип вида СправочникСсылка.*,
		// ДокументСсылка.* и т.д. - на этом этапе проверка выполняться не будет, т.к. разработчик мог
		// подразумевать любую ссылку разделенного ссылочного объекта метаданных.
		//
		// Информация об объекте и реквизите будет сохранена в кэше и в дальнейшем использована
		// для выполнения проверки во время выгрузки тех данных, которые реально будут выгружаться.
		//
		
		Если Кэш.Получить(ОбъектМетаданных.ПолноеИмя()) = Неопределено Тогда
			Кэш.Вставить(ОбъектМетаданных.ПолноеИмя(), Новый Массив());
		КонецЕсли;
		
		Кэш.Получить(ОбъектМетаданных.ПолноеИмя()).Добавить(Поле.ПолноеИмя());
		
	Иначе
		
		Для Каждого ТипПоля Из ТипыПоля.Типы() Цикл
			
			Если Не ОбщегоНазначенияБТС.ЭтоПримитивныйТип(ТипПоля) И Не (ТипПоля = Тип("ХранилищеЗначения")) Тогда
				
				МетаданныеСсылки = ВыгрузкаЗагрузкаДанныхСлужебный.ОбъектМетаданныхПоТипуСсылки(ТипПоля);
				
				Если ТипыОбщихДанных.Найти(МетаданныеСсылки) = Неопределено
						И Не ОбщегоНазначенияБТС.ЭтоПеречисление(МетаданныеСсылки)
						И Не ВыгрузкаЗагрузкаНеразделенныхДанных.ОбъектМетаданныхРазделенХотьОднимРазделителем(МетаданныеСсылки, ЛокальныйКэшСоставовРазделителей) Тогда
					
					Если ОбъектыНеТребующиеСопоставленияСсылок.Найти(МетаданныеСсылки) = Неопределено Тогда
						
						ВызватьИсключениеПриНаличииВРазделенныхДанныхСсылокНаНеразделенныеБезПоддержкиСопоставленияСсылок(
							ОбъектМетаданных,
							Поле.ПолноеИмя(),
							МетаданныеСсылки,
							Ложь
						);
						
					Иначе
						
						Если Кэш.Получить(ОбъектМетаданных.ПолноеИмя()) = Неопределено Тогда
							Кэш.Вставить(ОбъектМетаданных.ПолноеИмя(), Новый Массив());
						КонецЕсли;
						
						Кэш.Получить(ОбъектМетаданных.ПолноеИмя()).Добавить(Поле.ПолноеИмя());
						
					КонецЕсли;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВызватьИсключениеПриНаличииВРазделенныхДанныхСсылокНаНеразделенныеБезПоддержкиСопоставленияСсылок(Знач ОбъектМетаданных, Знач ИмяПоля, Знач МетаданныеСсылки, Знач ПриВыгрузке)
	
	Если ОбщегоНазначенияБТС.ЭтоКонстанта(ОбъектМетаданных) Тогда
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru='В качестве значения разделенной константы %1 используются ссылки на
                  |неразделенный объект %2'
                  |;uk='В якості значення розділеної константи %1 використовуються посилання на
                  |неподільний об''єкт %2'",Метаданные.ОсновнойЯзык.КодЯзыка),
			ОбъектМетаданных.ПолноеИмя(),
			МетаданныеСсылки.ПолноеИмя()
		);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоСсылочныеДанные(ОбъектМетаданных) Тогда
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru='В качестве значения реквизита %1 разделенного объекта %2 используются ссылки на
                  |неразделенный объект %3'
                  |;uk='В якості значення реквізиту %1 розділеного об''єкту %2 використовуються посилання на
                  |неподільний об''єкт %3'",Метаданные.ОсновнойЯзык.КодЯзыка),
			ИмяПоля,
			ОбъектМетаданных.ПолноеИмя(),
			МетаданныеСсылки.ПолноеИмя()
		);
		
	ИначеЕсли ОбщегоНазначенияБТС.ЭтоНаборЗаписей(ОбъектМетаданных) Тогда
		
		ТекстОшибки = СтрШаблон(
			НСтр("ru='В качестве значения измерения, ресурса или реквизита %1 разделенного набора записей %2 используются ссылки на
                  |неразделенный объект %3'
                  |;uk='В якості значення вимірювання, ресурсу або реквізиту %1 розділеного набору записів %2 використовуються посилання на
                  |нероздільний об''єкт %3'",Метаданные.ОсновнойЯзык.КодЯзыка),
			ИмяПоля,
			ОбъектМетаданных.ПолноеИмя(),
			МетаданныеСсылки.ПолноеИмя()
		);
		
	Иначе
		
		ВызватьИсключение СтрШаблон(НСтр("ru='Неожиданный объект метаданных: %1!';uk='Несподіваний об''єкт метаданих: %1!'",Метаданные.ОсновнойЯзык.КодЯзыка),
			ОбъектМетаданных.ПолноеИмя()
		);
		
	КонецЕсли;
	
	Если ПриВыгрузке Тогда
		
		ТекстОшибки = ТекстОшибки +
			НСтр("ru=' (в качестве типа значения для объекта установлен составной тип данных,
                  |который может содержать ссылки как на разделенные данные, так и на неразделенные,
                  |но при выгрузке была диагностирована попытка выгрузки ссылки на неразделенный объект).'
                  |;uk=' (в якості типу значення для об''єкта встановлений складовий тип даних,
                  |який може містити посилання як на розділені дані, так і на нерозділені,
                  |але при вивантаженні була діагностована спроба вивантаження посилання на нерозділений об''єкт).'",Метаданные.ОсновнойЯзык.КодЯзыка);
		
	Иначе
		
		ТекстОшибки = ТекстОшибки + ".";
		
	КонецЕсли;
	
	ДополнениеОшибки = СтрШаблон(
		НСтр("ru='При этом неразделенный объект %1 не включен в состав типов общих данных,
              |для которых возможно выполнение сопоставления ссылок при выгрузке и загрузке.
              |Данная ситуация является недопустимой, т.к. при загрузке выгруженных данных в другую ИБ
              |будут загружены ""битые"" ссылки на объект %1.
              |
              |Для исправления ситуации требуется реализовать для объекта %1 механизм определения
              |полей, однозначно определяющих естественный ключ объекта и включить объект %1 в состав
              |типов общих данных, для которых возможно выполнение сопоставления ссылок при
              |выгрузке и загрузке, указав объект метаданных %1 в процедуре
              |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке().'
              |;uk='При цьому нероздільний об''єкт %1 не включений до складу загальних типів даних,
              |для яких можливе виконання зіставлення посилань при ви вантаженні та завантаженні.
              |Дана ситуація є неприпустимою, оскільки при завантаженні вивантажених даних в іншу ІБ
              |будуть завантажені ""биті"" посилання на об''єкт %1.
              |
              |Для виправлення ситуації потрібно реалізувати для об''єкту %1 механізм визначення
              |полів, які однозначно визначають природний ключ об''єкта та включити об''єкт %1у склад
              |типів загальних даних, для яких можливе виконання зіставлення посилань при
              |вивантаженні та завантаженні, вказавши об''єкт метаданих %1 у процедурі
              |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхПоддерживающихСопоставлениеСсылокПриЗагрузке().'",Метаданные.ОсновнойЯзык.КодЯзыка),
		МетаданныеСсылки.ПолноеИмя()
	);
	
	Если Не ПриВыгрузке Тогда
		
		ДополнениеОшибки = ДополнениеОшибки + СтрШаблон(
			НСтр("ru='
                  |Если корректное сопоставление ссылок на неразделенные данные в ИБ, из которой выгружены
                  |данные и ИБ, в которую они загружаются, гарантируется с помощью других механизмов, необходимо
                  |указать объект метаданных %1 в процедуре
                  |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке().'
                  |;uk='
                  |Якщо коректне зіставлення посилань на нерозділені дані в ІБ, з якої вивантажені
                  |дані та ІБ, в яку вони завантажуються, гарантується за допомогою інших механізмів, необхідно
                  |вказати об''єкт метаданих %1 у процедурі
                  |ВыгрузкаЗагрузкаДанныхПереопределяемый.ПриЗаполненииТиповОбщихДанныхНеТребующихСопоставлениеСсылокПриЗагрузке().'",Метаданные.ОсновнойЯзык.КодЯзыка),
			МетаданныеСсылки.ПолноеИмя()
		);
		
	КонецЕсли;
	
	ВызватьИсключение ТекстОшибки + Символы.ПС + Символы.ВК + ДополнениеОшибки;
	
КонецПроцедуры

#КонецОбласти