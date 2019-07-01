
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтруктураНастроек") Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.СтруктураНастроек);
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураНастроек);
		
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(ВидЦены) Тогда
		ВидЦены = ЦенообразованиеВызовСервера.ВидЦеныПрайсЛист();
	КонецЕсли;
	
	СкорректироватьВариантЗаполненияЦен(ЭтотОбъект);
	
	УстановитьВидимостьСтраницФормыИДоступностьЭлементов();

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НепроверяемыеРеквизиты = Новый Массив();
	
	Если Не (ВариантЗаполненияЦен = "ЦеныНоменклатуры" и ИспользоватьВидЦены) Тогда
		НепроверяемыеРеквизиты.Добавить("ВидЦены");
	КонецЕсли;
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, НепроверяемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

&НаКлиенте
Процедура ВариантЗаполненияЦенСоглашениеПриИзменении(Элемент)
	
	ПриИзмененииВариантаЦен(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантЗаполненияЦенПартнерПриИзменении(Элемент)
	
	ПриИзмененииВариантаЦен(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьИЗакрыть(Команда)
	
	ЗаполнитьЗначенияСвойств(СтруктураНастроек, ЭтотОбъект);
	
	ВсеЗаполнено = ПроверитьЗаполнение();
	
	Если ВсеЗаполнено Тогда
		Закрыть(СтруктураНастроек);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПриИзмененииВариантаЦен(Форма)
	
	Если Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры" Тогда
		Форма.Элементы.ВидЦеныПартнер.Доступность 	= Истина;
		Форма.Элементы.ВидЦеныСоглашение.Доступность= Истина;
		Форма.ИспользоватьВидЦены = Истина;
	Иначе
		Форма.Элементы.ВидЦеныПартнер.Доступность 	= Ложь;
		Форма.Элементы.ВидЦеныСоглашение.Доступность= Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура СкорректироватьВариантЗаполненияЦен(Форма)

	Если Форма.ЗаполнятьПартнера и Форма.ВариантЗаполненияЦен = "ЦеныНоменклатурыПоставщиков" и не Форма.ЗаполнятьСоглашение Тогда
		Форма.ВариантЗаполненияЦен = "МинимальнаяЦенаПоставщика";
	ИначеЕсли Форма.ЗаполнятьСоглашение и Форма.ВариантЗаполненияЦен = "МинимальнаяЦенаПоставщика" Тогда
		Форма.ВариантЗаполненияЦен = "ЦеныНоменклатурыПоставщиков";
	ИначеЕсли Не Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры" и не Форма.ЗаполнятьПартнера и не Форма.ЗаполнятьСоглашение Тогда
		Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры";
	КонецЕсли;
	
	Если Форма.ВариантЗаполненияЦен = "ЦеныНоменклатуры" И (Форма.ЗаполнятьПартнера ИЛИ Форма.ЗаполнятьСоглашение) Тогда
		Форма.ИспользоватьВидЦены = Истина;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьСтраницФормыИДоступностьЭлементов()
	
	Если ЗаполнятьПартнера Тогда
		Если ЗаполнятьСоглашение Тогда
			Элементы.ГруппаЦеныЗакупки.ТекущаяСтраница = Элементы.ГруппаЦеныСоглашение;
		Иначе
			Элементы.ГруппаЦеныЗакупки.ТекущаяСтраница = Элементы.ГруппаЦеныПартнер;
		КонецЕсли;
	Иначе
		Элементы.ГруппаЦеныЗакупки.ТекущаяСтраница = Элементы.ГруппаВидЦеныЗакупки;
		ИспользоватьВидЦены = Истина;
	КонецЕсли;
	
	ПриИзмененииВариантаЦен(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти