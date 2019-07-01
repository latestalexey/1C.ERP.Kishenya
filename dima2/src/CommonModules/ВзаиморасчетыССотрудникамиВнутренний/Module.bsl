Процедура ЗарегистрироватьНачисленнуюЗарплату(Движения, Отказ, Организация, ПериодРегистрации, ХарактерВыплаты, Начисления = Неопределено, Удержания = Неопределено) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ЗарегистрироватьНачисленнуюЗарплату(Движения, Отказ, Организация, ПериодРегистрации, ХарактерВыплаты, Начисления, Удержания);
КонецПроцедуры

Процедура ЗарегистрироватьВыплаченнуюЗарплату(Движения, Отказ, Организация, ПериодРегистрации, Зарплата) Экспорт
	ВзаиморасчетыССотрудникамиБазовый.ЗарегистрироватьВыплаченнуюЗарплату(Движения, Отказ, Организация, ПериодРегистрации, Зарплата)
КонецПроцедуры

Процедура ЗарегистрироватьНачальныеОстатки(Движения, Отказ, Организация, ПериодРегистрации, Остатки) Экспорт
	ВзаиморасчетыССотрудникамиБазовый.ЗарегистрироватьНачальныеОстатки(Движения, Отказ, Организация, ПериодРегистрации, Остатки)
КонецПроцедуры

Процедура СпособыВыплатыЗарплатыНачальноеЗаполнение() Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СпособыВыплатыЗарплатыНачальноеЗаполнение();
КонецПроцедуры	

Процедура СпособыВыплатыЗарплатыЗаполнитьПризнакПоставляемый() Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СпособыВыплатыЗарплатыЗаполнитьПризнакПоставляемый()
КонецПроцедуры	

Функция ДанныеЗаполненияВедомости() Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ДанныеЗаполненияВедомости()
КонецФункции	

Процедура ЗарегистрироватьНевыплатуПоВедомости(Движения, Отказ, Ведомость, ФизическиеЛица) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ЗарегистрироватьНеВыплатуПоВедомости(Движения, Отказ, Ведомость, ФизическиеЛица)
КонецПроцедуры

Функция СпособВыплатыПоРасчетномуДокументу(РасчетныйДокумент) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.СпособВыплатыПоРасчетномуДокументу(РасчетныйДокумент)
КонецФункции

Функция МенеджерДокументаВедомостьПоВидуМестаВыплаты(ВидМестаВыплаты) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.МенеджерДокументаВедомостьПоВидуМестаВыплаты(ВидМестаВыплаты)
КонецФункции

Функция ВидВзаиморасчетовССотрудникамиПоХарактеруВыплатыЗарплаты(ХарактерВыплаты) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ВидВзаиморасчетовССотрудникамиПоХарактеруВыплатыЗарплаты(ХарактерВыплаты)
КонецФункции

Функция ПараметрыПолученияЗарплатыКВыплате() Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ПараметрыПолученияЗарплатыКВыплате()
КонецФункции

Функция ПараметрыПолученияЗарплатыКВыплатеВедомости(Ведомость) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ПараметрыПолученияЗарплатыКВыплатеВедомости(Ведомость)
КонецФункции

Процедура СоздатьВТЗарплатаКВыплате(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СоздатьВТЗарплатаКВыплате(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники)
КонецПроцедуры	

Процедура СоздатьВТПлановыйАванс(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники, КадровыеДанные) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СоздатьВТПлановыйАванс(МенеджерВременныхТаблиц, ТолькоРазрешенные, Параметры, ИмяВТСотрудники, КадровыеДанные);
КонецПроцедуры

Процедура СоздатьВТСотрудникиДляВедомостиПоШапке(МенеджерВременныхТаблиц, Ведомость) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СоздатьВТСотрудникиДляВедомостиПоШапке(МенеджерВременныхТаблиц, Ведомость)
КонецПроцедуры	

Процедура СоздатьВТСотрудникиДляВедомостиПоФизическимЛицам(МенеджерВременныхТаблиц, Ведомость, ФизическиеЛица) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СоздатьВТСотрудникиДляВедомостиПоФизическимЛицам(МенеджерВременныхТаблиц, Ведомость, ФизическиеЛица)
КонецПроцедуры	

Функция ВедомостьВКассуМестоВыплаты(Ведомость) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВКассуМестоВыплаты(Ведомость);
КонецФункции	

Процедура ВедомостьВКассуУстановитьМестоВыплаты(Ведомость, Значение) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВКассуУстановитьМестоВыплаты(Ведомость, Значение);
КонецПроцедуры	

Функция ВедомостьМожноЗаполнитьЗарплату(Ведомость) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ВедомостьМожноЗаполнитьЗарплату(Ведомость)
КонецФункции

Процедура ВедомостьЗарплатаКВыплатеРассчитатьСуммы(Ведомость, ЗарплатаКВыплате) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьЗарплатаКВыплатеРассчитатьСуммы(Ведомость, ЗарплатаКВыплате)
КонецПроцедуры

Функция ВедомостьСоставПоТаблицеЗарплат(Ведомость, ТаблицаЗарплат) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ВедомостьСоставПоТаблицеЗарплат(Ведомость, ТаблицаЗарплат)
КонецФункции

Процедура ВедомостьОчиститьСостав(Ведомость) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьОчиститьСостав(Ведомость)
КонецПроцедуры	

Процедура ВедомостьДополнитьСостав(Ведомость, Состав) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьДополнитьСостав(Ведомость, Состав)
КонецПроцедуры

Процедура ВедомостьОбработкаЗаполнения(ДокументОбъект, ДанныеЗаполнения, СтандартнаяОбработка) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьОбработкаЗаполнения(ДокументОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
КонецПроцедуры

Процедура ВедомостьПередЗаписью(ДокументОбъект, Отказ, РежимЗаписи) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьПередЗаписью(ДокументОбъект, Отказ, РежимЗаписи)
КонецПроцедуры

Процедура ВедомостьЗарегистрироватьВыплату(Ведомость, Отказ) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьЗарегистрироватьВыплату(Ведомость, Отказ);
КонецПроцедуры

Процедура ВедомостьВБанкДобавитьКомандыПечати(КомандыПечати) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВБанкДобавитьКомандыПечати(КомандыПечати)
КонецПроцедуры

Процедура ВедомостьВБанкПечать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВБанкПечать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
КонецПроцедуры

Функция ВедомостьВБанкВыборкаДляПечатиШапки(ИмяТипа, Ведомости) Экспорт
	Возврат ВзаиморасчетыССотрудникамиБазовый.ВедомостьВБанкВыборкаДляПечатиШапки(ИмяТипа, Ведомости)
КонецФункции
	
Функция ВедомостьВБанкВыборкаДляПечатиТаблицы(ИмяТипа, Ведомости) Экспорт
	Возврат ВзаиморасчетыССотрудникамиБазовый.ВедомостьВБанкВыборкаДляПечатиТаблицы(ИмяТипа, Ведомости)
КонецФункции

Процедура ВедомостьВКассуДобавитьКомандыПечати(КомандыПечати) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВКассуДобавитьКомандыПечати(КомандыПечати)
КонецПроцедуры

Процедура ВедомостьВКассуПечать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВКассуПечать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода)
КонецПроцедуры

Функция ВедомостьВКассуВыборкаДляПечатиШапки(ИмяТипа, Ведомости) Экспорт
	Возврат ВзаиморасчетыССотрудникамиРасширенный.ВедомостьВКассуВыборкаДляПечатиШапки(ИмяТипа, Ведомости)
КонецФункции

Функция ВедомостьВКассуВыборкаДляПечатиТаблицы(ИмяТипа, Ведомости) Экспорт
	Возврат ВзаиморасчетыССотрудникамиБазовый.ВедомостьВКассуВыборкаДляПечатиТаблицы(ИмяТипа, Ведомости)
КонецФункции

Процедура СпособыВыплатыЗарплатыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка) Экспорт
	ВзаиморасчетыССотрудникамиРасширенный.СпособыВыплатыЗарплатыОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
КонецПроцедуры
