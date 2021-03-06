
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ДанныеОбъекта = Справочники.ЭлементыФинансовыхОтчетов.ФормаПриСозданииНаСервере(ЭтаФорма);
	ВариантРасположенияГраницыФактическихДанных = Параметры.ВариантРасположенияГраницыФактическихДанных;
	
	Заголовок = "";
	Если Параметры.Свойство("ПроизвольныйПоказатель") Тогда
		Заголовок = "Операнд: ";
		Элементы.ОтрицательноеЗначение.Видимость = Ложь;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПоказательБюджетов) Тогда
		Заголовок = Заголовок + НСтр("ru='<Показатели бюджетов, по которым есть остатки или обороты>';uk='<Показники бюджетів, за якими є залишки або обороти>'");
	Иначе
		Заголовок = Заголовок + Строка(Параметры.ВидЭлемента) + " """ + ПоказательБюджетов + """";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ПоказательБюджетов) ИЛИ ПоказательБюджетов.УчитыватьПоКоличеству Тогда
		Элементы.ВыводимыеПоказатели.СписокВыбора.Добавить(Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.Количество);
		Если Не Параметры.Свойство("НастройкаЯчеек")
			И Не Параметры.Свойство("ПроизвольныйПоказатель") Тогда
			Элементы.ВыводимыеПоказатели.СписокВыбора.Добавить(Перечисления.ТипыВыводимыхПоказателейБюджетногоОтчета.КоличествоИСумма);
		КонецЕсли;
	КонецЕсли;

	Если НЕ (Параметры.Свойство("НастройкаЯчеек")
		ИЛИ Параметры.Свойство("ПроизвольныйПоказатель")) Тогда
		
		ДеревоЭлементов = ДанныеФормыВЗначение(Параметры.ЭлементыОтчета, Тип("ДеревоЗначений"));
		АдресЭлементовОтчета = ПоместитьВоВременноеХранилище(ДеревоЭлементов, УникальныйИдентификатор);
		АдресРедактируемогоЭлемента = АдресЭлементаВХранилище;
		АдресТаблицыЭлементов = Неопределено;
		
	Иначе
		
		АдресЭлементовОтчета = Параметры.АдресЭлементовОтчета;
		Если Параметры.Свойство("ПроизвольныйПоказатель") Тогда
			АдресРедактируемогоЭлемента = Параметры.АдресРедактируемогоЭлемента;
		Иначе
			АдресРедактируемогоЭлемента = АдресЭлементаВХранилище;
		КонецЕсли;
		АдресТаблицыЭлементов = Параметры.АдресТаблицыЭлементов;
	
	КонецЕсли;
	
	ПараметрыОпределенияФильтров = Новый Структура;
	ПараметрыОпределенияФильтров.Вставить("АдресРедактируемогоЭлемента", АдресРедактируемогоЭлемента);
	ПараметрыОпределенияФильтров.Вставить("АдресЭлементовОтчета", АдресЭлементовОтчета);
	Если ЗначениеЗаполнено(АдресТаблицыЭлементов) Тогда
		ПараметрыОпределенияФильтров.Вставить("АдресТаблицыЭлементов", АдресТаблицыЭлементов);
	КонецЕсли;
	
	ПараметрыДоступностиФильтров = БюджетнаяОтчетностьРасчетКэшаСервер.ПараметрыДоступностиФильтров(, ПараметрыОпределенияФильтров);
	
	Для Каждого КлючИЗначение из ПараметрыДоступностиФильтров Цикл
		Элементы["ЗаголовокФильтр" + КлючИЗначение.Ключ].Видимость 			= КлючИЗначение.Значение;
		Элементы["НеИспользоватьФильтрПо" + КлючИЗначение.Ключ].Видимость 	= КлючИЗначение.Значение;
		Элементы["ИспользоватьФильтрПо" + КлючИЗначение.Ключ].Видимость 	= КлючИЗначение.Значение;
	КонецЦикла;
	
	Элементы.НастройкаСмещенияПериода.Заголовок = БюджетнаяОтчетностьКлиентСервер.ПредставлениеСмещения(ЭтаФорма);
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Справочники.ЭлементыФинансовыхОтчетов.ФормаПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект, Отказ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(АдресЭлементаВХранилище) Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаСмещенияПериодаНажатие(Элемент)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("УстановитьПериодСмещения", ЭтаФорма);
	ПараметрыСмещения = БюджетнаяОтчетностьКлиентСервер.ПараметрыОткрытияФормыНастройкиПериода(ЭтаФорма);
	
	ОткрытьФорму("Справочник.ЭлементыФинансовыхОтчетов.Форма.НастройкаПериодаИсточникаДанных",
															ПараметрыСмещения,,,,,ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура НеИспользоватьФильтрПриИзменении(Элемент)
	
	УстановитьОтборНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	
	ФинансоваяОтчетностьКлиент.ЗавершитьРедактированиеЭлементаОтчета(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПериодСмещения(Результат, ДополнительныеПараметры) Экспорт
	
	БюджетнаяОтчетностьКлиент.УстановитьПериодСмещения(Объект, ЭтаФорма, Результат);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборНаСервере()
	
	Справочники.ЭлементыФинансовыхОтчетов.УстановитьНастройкиОтбора(ЭтаФорма, ЭтаФорма.Компоновщик, Объект.ВидЭлемента, Компоновщик.Настройки);
	
КонецПроцедуры

#КонецОбласти

