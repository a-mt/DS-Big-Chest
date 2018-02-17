
-- List all the assets it requires.
-- These can be either standard assets, or custom ones in your mod folder.
local Assets =
{
    Asset("ANIM", "anim/big_chest.zip"),
    Asset("ANIM", "anim/ui_chest_5x5.zip"),
    Asset("ANIM", "anim/ui_chest_9x9.zip"),
    Asset("ATLAS", "images/inventoryimages/big_chest.xml"),
}

local function onopen(inst) 
    inst.AnimState:PlayAnimation("open") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
end 

local function onclose(inst) 
    inst.AnimState:PlayAnimation("close") 
    inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
end 

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    inst.components.container:DropEverything()
    SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.components.container:DropEverything()
    inst.AnimState:PushAnimation("closed", false)
    inst.components.container:Close()
end

local function onbuilt(inst)
    inst.AnimState:PlayAnimation("place")
    inst.AnimState:PushAnimation("closed", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/craftable/chest")
end

local function chest(style)
    local fn = function()
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()

        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon( "big_chest.png" )

        inst:AddTag("structure")
        inst.AnimState:SetBank("chest")
        inst.AnimState:SetBuild("big_chest")
        inst.AnimState:PlayAnimation("closed")

        inst:AddComponent("inspectable")
        inst:AddComponent("container")

        local slotpos = {}
        if style == "big_chest" then
            for y = 8, 0, -1 do
                for x = 0, 8 do
                    table.insert(slotpos, Vector3(75*x-300, 75*y-300, 0))
                end
            end
            inst.components.container.widgetslotpos = slotpos
            inst.components.container.widgetanimbank = "ui_chest_9x9"
            inst.components.container.widgetanimbuild = "ui_chest_9x9"
        else
            for y = 4, 0, -1 do
                for x = 0, 4 do
                    table.insert(slotpos, Vector3(75*x-150, 75*y-150, 0)) -- -(70*2+10)
                end
            end
            inst.components.container.widgetslotpos = slotpos
            inst.components.container.widgetanimbank = "ui_chest_5x5"
            inst.components.container.widgetanimbuild = "ui_chest_5x5"
        end
        inst.components.container.widgetpos = Vector3(0,200,0)
        inst.components.container.side_align_tip = 160

        inst.components.container:SetNumSlots(#slotpos)
        inst.components.container.onopenfn = onopen
        inst.components.container.onclosefn = onclose

        inst:AddComponent("lootdropper")
        inst:AddComponent("workable")
        inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
        inst.components.workable:SetWorkLeft(2)
        inst.components.workable:SetOnFinishCallback(onhammered)
        inst.components.workable:SetOnWorkCallback(onhit) 

        inst:ListenForEvent( "onbuilt", onbuilt)
        MakeSnowCovered(inst, .01)
        return inst
    end
    return fn
end

-- Finally, return a new prefab with the construction function and assets.
return Prefab( "common/big_chest", chest("big_chest"), Assets),
       Prefab( "common/medium_chest", chest("medium_chest"), Assets)