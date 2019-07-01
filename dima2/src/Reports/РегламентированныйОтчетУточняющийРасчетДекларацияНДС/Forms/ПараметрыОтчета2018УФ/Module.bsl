
// ПриСозданииНаСервере()
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	мСпрашиватьОСохранении = Истина;
	мПрограммноеЗакрытие   = Ложь;
	
	Организация = Параметры.Организация;
	
	мДатаНачалаПериодаОтчета = Параметры.мДатаНачалаПериодаОтчета;
	мДатаКонцаПериодаОтчета  = Параметры.мДатаКонцаПериодаОтчета;
	
	ПроцентШтрафа 		   = Параметры.ПроцентШтрафа;
	УточняемыйОтчет 	   = Параметры.УточняемыйОтчет;
	ДатаНач 			   = Параметры.ДатаНач;
	ДатаКон 			   = Параметры.ДатаКон;
	
	HZYP 			   = Параметры.HZYP;
	HZMP 			   = Параметры.HZMP;
	HZKVP 			   = Параметры.HZKVP;
	
	//ИмяПоляТипа		   = Параметры.ИмяПоляТипа;
	мСохраненныйДок	   = Параметры.мСохраненныйДок;
	НеВыдаватьСообщенияОбОшибкахВРасчете = Параметры.НеВыдаватьСообщенияОбОшибкахВРасчете;
	
	Элементы.Предупреждение1.Видимость = Ложь;
	Элементы.Предупреждение2.Видимость = Ложь;
	Элементы.ТаблицаВыбора.Доступность = Истина;
	Если НЕ ЗначениеЗаполнено(HZYP) 
		ИЛИ (НЕ ЗначениеЗаполнено(HZMP) И НЕ ЗначениеЗаполнено(HZKVP))
		ИЛИ (ЗначениеЗаполнено(HZMP) И ЗначениеЗаполнено(HZKVP)) Тогда
		Элементы.Предупреждение1.Видимость = Истина;
		Элементы.ТаблицаВыбора.Доступность = Ложь;
	Иначе
		
		ПолучитьТаблицуОтчетов();
		
		Если ТаблицаВыбора.Количество() = 0 Тогда
			Элементы.Предупреждение2.Видимость = Истина;
			Элементы.ТаблицаВыбора.Доступность = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ПриСозданииНаСервере()

// Сохранить()
//
&НаКлиенте
Процедура Сохранить(Команда)
	
	мСпрашиватьОСохранении = Ложь;
	Закрыть();
	
КонецПроцедуры // Сохранить()

// ПередЗакрытием()
//
&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если мПрограммноеЗакрытие = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ПроверитьЗаполнение() Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если мСпрашиватьОСохранении <> Ложь И Модифицированность Тогда
		
		Отказ = Истина;
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеОповещения, НСтр("ru='Настройки были изменены. Сохранить изменения?';uk='Настройки були змінені. Зберегти зміни?'"), РежимДиалогаВопрос.ДаНетОтмена);
		Возврат;
		
	ИначеЕсли мСпрашиватьОСохранении <> Ложь И НЕ Модифицированность Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ДействияПриЗакрытии()
	
	ВладелецФормы.СтруктураРеквизитовФормы.ПроцентШтрафа = ПроцентШтрафа;
	ВладелецФормы.СтруктураРеквизитовФормы.ДатаНач = ДатаНач;
	ВладелецФормы.СтруктураРеквизитовФормы.ДатаКон = ДатаКон;
	ВладелецФормы.СтруктураРеквизитовФормы.НеВыдаватьСообщенияОбОшибкахВРасчете = НеВыдаватьСообщенияОбОшибкахВРасчете;
	
	
	ВыбраннаяСтрока = ТаблицаВыбора.НайтиСтроки(Новый Структура("Пометка", Истина));
	Если ВыбраннаяСтрока.Количество() > 0 Тогда
		ВладелецФормы.СтруктураРеквизитовФормы.УточняемыйОтчет = ВыбраннаяСтрока[0].Ссылка;	
	Иначе
		ВладелецФормы.СтруктураРеквизитовФормы.УточняемыйОтчет = Неопределено;
	КонецЕсли;
	
	мПрограммноеЗакрытие = Истина;
	Отказ = Истина;
	
	ПараметрыВозврата = Новый Структура();
	
	Закрыть(ПараметрыВозврата);
	
КонецПроцедуры // ПередЗакрытием()

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(Ответ, ДополнительныеПараметры)Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		мПрограммноеЗакрытие = Истина;
		Закрыть();
		Возврат;
	ИначеЕсли Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	ДействияПриЗакрытии();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборПериодаЗаписей(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ДатыВыборкиПриИзменении(Элемент)

	Если ДатаНач = '00010101'Тогда
		ДатаНач = мДатаНачалаПериодаОтчета;
	КонецЕсли;	
	
	Если ДатаНач > ДатаКон Тогда
	
		ДатаКон = ДатаНач;	
	
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуОтчетов()
	
	Если ЗначениеЗаполнено(HZMP) Тогда
		ТекДатаОкончания = КонецМесяца(Дата(HZYP,HZMP,1));
	Иначе
		ТекДатаОкончания = КонецМесяца(Дата(HZYP,HZKVP*3,1));
	КонецЕсли;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр ("ДатаОкончания",	ТекДатаОкончания);
	Запрос.УстановитьПараметр ("Организация",	Организация);
	Запрос.УстановитьПараметр ("Декларация","РегламентированныйОтчетДекларацияНДС");
    Запрос.УстановитьПараметр ("Уточненка", "РегламентированныйОтчетУточняющийРасчетДекларацияНДС");
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	1 КАК ТипОтчета,
	               |	РегламентированныйОтчет.ДатаНачала КАК ДатаНачала,
	               |	РегламентированныйОтчет.ДатаОкончания,
	               |	РегламентированныйОтчет.ПредставлениеПериода КАК ПредставлениеПериода,
	               |	РегламентированныйОтчет.ДанныеОтчета КАК ДанныеОтчета,
	               |	РегламентированныйОтчет.НаименованиеОтчета КАК НаименованиеОтчета,
	               |	РегламентированныйОтчет.Комментарий КАК Комментарий,
	               |	РегламентированныйОтчет.Ссылка
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	               |ГДЕ
	               |	РегламентированныйОтчет.ПометкаУдаления = ЛОЖЬ
	               |	И РегламентированныйОтчет.Организация = &Организация
	               |	И РегламентированныйОтчет.ИсточникОтчета = &Декларация
				   //|	И РегламентированныйОтчет.ДатаОкончания = &ДатаОкончания
				   |	И НАЧАЛОПЕРИОДА(РегламентированныйОтчет.ДатаОкончания,ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаОкончания,ДЕНЬ)
				   |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	2,
	               |	РегламентированныйОтчет.ДатаНачала,
	               |	РегламентированныйОтчет.ДатаОкончания,
	               |	РегламентированныйОтчет.ПредставлениеПериода,
	               |	РегламентированныйОтчет.ДанныеОтчета,
	               |	РегламентированныйОтчет.НаименованиеОтчета,
	               |	РегламентированныйОтчет.Комментарий,
	               |	РегламентированныйОтчет.Ссылка
	               |ИЗ
	               |	Документ.РегламентированныйОтчет КАК РегламентированныйОтчет
	               |ГДЕ
	               |	РегламентированныйОтчет.ПометкаУдаления = ЛОЖЬ
	               |	И РегламентированныйОтчет.Организация = &Организация
	               |	И РегламентированныйОтчет.ИсточникОтчета = &Уточненка
	               |	И РегламентированныйОтчет.ДатаОкончания >= &ДатаОкончания
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ДатаОкончания";
				   
	ТаблицаВыбора.Очистить();
	
	Выборка = Запрос.Выполнить().Выбрать();
	ЕстьУточненки = Ложь;
	Пока Выборка.Следующий() Цикл
	
		Если Выборка.ТипОтчета = 2 Тогда
			
			Если НЕ мСохраненныйДок = Неопределено Тогда
			
				Если мСохраненныйДок.Ссылка = Выборка.Ссылка Тогда
					Продолжить;
				КонецЕсли;	
			
			КонецЕсли;
			
			ДанныеОтчета = Выборка.ДанныеОтчета.Получить();
			ПоказателиОтчета = ""; СлужебныеДанные = ""; HZYP_ = ""; HZKVP_ = ""; HZMP_ = ""; 
			ДанныеДекларации = ""; ЗначениеПоляТипа = "";
			Если  ТипЗнч(ДанныеОтчета) = Тип("Структура")
				И ДанныеОтчета.Свойство("ПоказателиОтчета",ПоказателиОтчета)
				И ПоказателиОтчета.Свойство("ПолеТабличногоДокументаСлужебныеДанные",СлужебныеДанные)
				И СлужебныеДанные.Свойство("HZYP",  HZYP_) 
				И СлужебныеДанные.Свойство("HZKVP", HZKVP_) 
				И СлужебныеДанные.Свойство("HZMP",  HZMP_)
				И Число(HZYP_)  = Число(HZYP) 
				И Число(HZKVP_) = Число(HZKVP) 
				И Число(HZMP_)  = Число(HZMP)
				//И (ПоказателиОтчета.Свойство("ПолеТабличногоДокументаДекларация",ДанныеДекларации)
				//   И ДанныеДекларации.Свойство(ИмяПоляТипа,  ЗначениеПоляТипа) 
				//   И ЗначениеЗаполнено(ЗначениеПоляТипа))
				Тогда
				
				// такой отчет подходит
				ЕстьУточненки = Истина;
				
			Иначе
				Продолжить;
			КонецЕсли;
		Иначе
			Если НЕ мСохраненныйДок = Неопределено Тогда
				Если мСохраненныйДок.Ссылка = Выборка.Ссылка Тогда
					Продолжить;
				КонецЕсли;	
			КонецЕсли;
			
			ДанныеОтчета = Выборка.ДанныеОтчета.Получить();
			ПоказателиОтчета = ""; 
			ДанныеДекларации = ""; ЗначениеПоляТипа = "";
			Если  ТипЗнч(ДанныеОтчета) = Тип("Структура")
				И ДанныеОтчета.Свойство("ПоказателиОтчета",ПоказателиОтчета)
				И (    ПоказателиОтчета.Свойство("ПолеТабличногоДокументаДекларация",     ДанныеДекларации)
 				   ИЛИ ПоказателиОтчета.Свойство("ПолеТабличногоДокументаДекларацияПоНДС",ДанныеДекларации))
				//И ДанныеДекларации.Свойство(ИмяПоляТипа,  ЗначениеПоляТипа) 
				//И ЗначениеЗаполнено(ЗначениеПоляТипа)
				Тогда
				
			Иначе
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;	
		
		СтрокаТаблицы = ТаблицаВыбора.Добавить();
		
		СтрокаТаблицы.НаименованиеОтчета = Выборка.НаименованиеОтчета;
		СтрокаТаблицы.Комментарий 		 = Выборка.Комментарий;
		СтрокаТаблицы.Ссылка 			 = Выборка.Ссылка;
		СтрокаТаблицы.Период 			 = Выборка.ПредставлениеПериода;
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(УточняемыйОтчет) Тогда
	
		ВыбраннаяСтрока = ТаблицаВыбора.НайтиСтроки(Новый Структура("Ссылка", УточняемыйОтчет));
		Если ВыбраннаяСтрока.Количество() = 0  Тогда
			СтрокаТаблицы = ТаблицаВыбора.Вставить(0);
			
			СтрокаТаблицы.НаименованиеОтчета = УточняемыйОтчет.НаименованиеОтчета;
			СтрокаТаблицы.Комментарий 		 = УточняемыйОтчет.Комментарий;
			СтрокаТаблицы.Ссылка 			 = УточняемыйОтчет.Ссылка;
			СтрокаТаблицы.Период 			 = УточняемыйОтчет.ПредставлениеПериода;
			СтрокаТаблицы.Пометка = Истина;
			
		Иначе
			
			ВыбраннаяСтрока[0].Пометка = Истина;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаВыбораПометкаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаВыбора.ТекущиеДанные;
	
	Для каждого СтрокаВыбора Из ТаблицаВыбора Цикл
		Если СтрокаВыбора.ПолучитьИдентификатор() = ТекущаяСтрока.ПолучитьИдентификатор() Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокаВыбора.Пометка = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаВыбораВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ Поле.Имя = "ТаблицаВыбораПометка" Тогда
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	ТекСтрока = ТаблицаВыбора.НайтиПоИдентификатору(ВыбраннаяСтрока);
	
	Если ЗначениеЗаполнено(ТекСтрока.Ссылка) Тогда
		ПоказатьЗначение(,ТекСтрока.Ссылка)
	КонецЕсли;
	
КонецПроцедуры
