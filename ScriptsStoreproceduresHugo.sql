USE [bd_pitsor]
GO

/****** Object:  StoredProcedure [dbo].[SP_GetResultsporPozo]    Script Date: 12/20/2019 3:10:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_GetResultsporPozo]
	
	--@Pozo int=0
          
AS
BEGIN
 DBCC FREEPROCCACHE;
 
SELECT *  FROM [bd_pitsor].[dbo].[RegistroResultado] A 
	  JOIN [dbo].[RegistroInfo] B on B.PozoId=A.PozoId and A.id_gr=B.Id
	  JOIN [dbo].[RegistroInfo] C on C.PozoId=A.PozoId and A.id_MSFL=C.Id
	  JOIN [dbo].[RegistroInfo] D on D.PozoId=A.PozoId and A.id_NPHI=D.Id
	  JOIN [dbo].[RegistroInfo] E on E.PozoId=A.PozoId and A.id_RHOB=E.Id
 --WHERE A.PozoId=@Pozo
END


GO

/****** Object:  StoredProcedure [dbo].[SP_ProveeCurvas]    Script Date: 12/20/2019 3:10:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_ProveeCurvas]
	
	@Pozo int=0
          
AS
BEGIN
 

SELECT concat(B.Alias,',',C.Alias,',',D.Alias,',',E.Alias) as curvas
	  FROM [bd_pitsor].[dbo].[RegistroResultado] A 
	  JOIN [dbo].[RegistroInfo] B on B.PozoId=A.PozoId and A.id_gr=B.Id
	  JOIN [dbo].[RegistroInfo] C on C.PozoId=A.PozoId and A.id_MSFL=C.Id
	  JOIN [dbo].[RegistroInfo] D on D.PozoId=A.PozoId and A.id_NPHI=D.Id
	  JOIN [dbo].[RegistroInfo] E on E.PozoId=A.PozoId and A.id_RHOB=E.Id
 WHERE A.PozoId=@Pozo
END


GO
/****** Object:  StoredProcedure [dbo].[SP_Q_Campo_Yacimiento_Coordenadas]    Script Date: 12/20/2019 3:10:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Q_Campo_Yacimiento_Coordenadas]
 @campoid int,
 @yacid int,
 @selsor int
 AS
BEGIN
    ----------------------------------------------------------------
	
DECLARE @qry NVARCHAR(MAX)


set @qry='select   G.x,cast(I.profundidad as int) as y,cast(G.y as int) as z  ,null color,(I.valor*Confiabilidad'+CAST(@selsor as varchar(10))+'/100) as percentage,F.pozo as pname
 from rel_campo_yacimiento_pozo A
LEFT JOIN cat_pozo F ON F.id_pozo=A.id_pozo
left join cat_pozos_coords G on G.IdPozo=A.id_pozo
LEFT JOIN ResultadoCuestionarios Z ON Z.IdPozo=F.id_pozo
JOIN cat_yacimiento D ON A.id_yacimiento=a.id_yacimiento
LEFT JOIN RegistroResultado H ON H.PozoId=F.id_pozo
LEFT JOIN RegistroDatos I ON I.RegistroInfoId=H.id_pickett'+CAST(@selsor as varchar(10))+' '+'
 LEFT JOIN RegistroInfo J ON J.Id =I.RegistroInfoId
LEFT JOIN cat_campo C ON C.id_campo=d.id_campo
where    C.id_campo=ISNULL('+CAST(@campoid as varchar(10))+',0) and A.id_yacimiento=ISNULL('+CAST(@yacid as varchar(10))+',0) and Z.IdPozo IS NOT null and I.valor>0
and (I.Profundidad>=H.profIni and I.Profundidad<=h.profFin) GROUP BY i.Profundidad,g.x,G.y,i.Valor,f.pozo,Z.Confiabilidad'+CAST(@selsor as varchar(10))+' order by F.pozo'
EXEC SP_EXECUTESQL @qry

END
GO
/****** Object:  StoredProcedure [dbo].[SP_Q_Campo_Yacimiento_Pozo]    Script Date: 12/20/2019 3:10:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Q_Campo_Yacimiento_Pozo]
 @campoid int=80,
 @yacid int=27
 AS
BEGIN
    
----------------------------------------------------------------
select  A.region, B.activo,C.id_campo, C.campo, d.id_yacimiento,D.yacimiento, G.tipo_yacimiento,H.sormean1, F.pozo,F.id_pozo,CASE WHEN Z.IdPozo IS NOT NULL THEN 'Procesado'  ELSE 'Sin Información' end estado, CASE WHEN F.estatus_pozo='R' THEN 'Real' WHEN F.estatus_pozo='F' THEN 'Futuro'  end estatus,
  Z.curvas,  ISNULL(Z.Confiabilidad,0) as Confiabilidad , ISNULL(Z.Sor,0)  as sor,H.sormean1,H.sormean2,H.sormean3,H.sormean4,
        H.picket1_m,H.[picket1_Rmf],H.[picket2_m],H.[picket2_Rmf],H.[picket3_m],H.[picket3_Rmf],H.[picket4_m],H.[picket4_Rmf],
		Z.sor1  as sor1,Z.sor2  as sor2,Z.sor3  ,Z.sor4,Z.sor5,Z.sor6,Z.RespuestasCuestionario1,Z.RespuestasCuestionario2,Z.RespuestasCuestionario3,Z.RespuestasCuestionario4,Z.RespuestasCuestionario5,Z.RespuestasCuestionario6,
		ISNULL(Z.Confiabilidad1,0) as Confiabilidad1,ISNULL(Z.Confiabilidad2,0)as Confiabilidad2,ISNULL(Z.Confiabilidad3,0)as Confiabilidad3,ISNULL(Z.Confiabilidad4,0)as Confiabilidad4,ISNULL(Z.Confiabilidad5,0)as Confiabilidad5,ISNULL(Z.Confiabilidad6,0)as Confiabilidad6,
  H.metodo1_m,H.metodo2_m,H.metodo3_m,H.metodo4_m from
cat_region A 
JOIN cat_activo B ON A.id_region=B.id_region
JOIN cat_campo C ON B.id_activo=C.id_activo
JOIN cat_yacimiento D ON D.id_campo=C.id_campo
LEFT JOIN rel_campo_yacimiento_pozo E on E.id_yacimiento=D.id_yacimiento
LEFT JOIN cat_pozo F ON F.id_pozo=E.id_pozo
LEFT JOIN RegistroResultado H ON H.PozoId=F.id_pozo
LEFT JOIN ResultadoCuestionarios Z ON Z.IdPozo=F.id_pozo
LEFT JOIN cat_tipo_yacimiento G on G.id_tipo_yacimiento=D.id_tipo_yacimiento
LEFT JOIN RespuestasPozos R on R.Idpozo=F.id_pozo
WHERE C.id_campo=ISNULL(@campoid,0) and D.id_yacimiento=ISNULL(@yacid,0) 
GROUP BY  A.region, B.activo, C.id_campo,C.campo,D.id_yacimiento, D.yacimiento, G.tipo_yacimiento,F.id_pozo, F.pozo,F.estatus_pozo,G.tipo_yacimiento,H.PozoId,H.sormean1,Z.curvas, Z.Confiabilidad,Z.Sor,H.sormean1,H.sormean2,H.sormean3,H.sormean4, H.metodo1_m,H.metodo2_m,H.metodo3_m,H.metodo4_m,
      H.picket1_m,H.picket1_Rmf,H.picket2_m,H.picket2_Rmf,H.picket3_m,H.picket3_Rmf,H.picket4_m,H.picket4_Rmf,	Z.sor1 ,	Z.sor2,Z.sor3,Z.sor4 ,Z.sor5  ,Z.sor6,Z.RespuestasCuestionario1,Z.RespuestasCuestionario2,Z.RespuestasCuestionario3,Z.RespuestasCuestionario4,Z.RespuestasCuestionario5,Z.RespuestasCuestionario6,
	  Z.Confiabilidad1,Z.Confiabilidad2,Z.Confiabilidad3,Z.Confiabilidad4,Z.Confiabilidad5,Z.Confiabilidad6,Z.IdPozo
	  
order by A.region, B.activo, C.campo, D.yacimiento, F.estatus_pozo DESC, F.pozo 
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Q_Campo_Yacimiento_Pozos_procesados]    Script Date: 12/20/2019 3:10:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_Q_Campo_Yacimiento_Pozos_procesados]
 @campoid int,
 @yacid int
 AS
BEGIN
    
----------------------------------------------------------------
select  A.region, B.activo,C.id_campo, C.campo, d.id_yacimiento,D.yacimiento, G.tipo_yacimiento,H.sormean1, F.pozo,F.id_pozo,CASE WHEN H.PozoId IS NOT NULL THEN 'Procesado'  ELSE 'Sin Información' end estado, CASE WHEN F.estatus_pozo='R' THEN 'Real' WHEN F.estatus_pozo='F' THEN 'Futuro'  end estatus
 from
cat_region A 
JOIN cat_activo B ON A.id_region=B.id_region
JOIN cat_campo C ON B.id_activo=C.id_activo
JOIN cat_yacimiento D ON D.id_campo=C.id_campo
LEFT JOIN rel_campo_yacimiento_pozo E on E.id_yacimiento=D.id_yacimiento
LEFT JOIN cat_pozo F ON F.id_pozo=E.id_pozo
JOIN RegistroResultado H ON F.id_pozo=H.PozoId
LEFT JOIN cat_tipo_yacimiento G on G.id_tipo_yacimiento=D.id_tipo_yacimiento
WHERE C.id_campo=@campoid and D.id_yacimiento=@yacid
GROUP BY  A.region, B.activo, C.id_campo,C.campo,D.id_yacimiento, D.yacimiento, G.tipo_yacimiento,F.id_pozo, F.pozo,F.estatus_pozo,G.tipo_yacimiento,H.PozoId,H.sormean1
order by A.region, B.activo, C.campo, D.yacimiento, F.estatus_pozo DESC, F.pozo
END
GO
/****** Object:  StoredProcedure [dbo].[SP_Reporte_activos]    Script Date: 12/20/2019 3:10:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--EXEC [SP_Reporte_produccion_Real] 'Aceite', 'Cantarell'
CREATE PROCEDURE [dbo].[SP_Reporte_activos]
	
          
AS
BEGIN

----------------------------------------------------------------
SELECt * from cat_activo
END


GO
